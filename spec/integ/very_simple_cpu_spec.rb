# frozen_string_literal: true

require_relative '../shared_examples/a_register'
require_relative '../support/very_simple_cpu'

RSpec.describe VerySimpleCPU, :integ do
  subject(:vs_cpu) { described_class.new }

  shared_context 'with an initialized memory' do
    before do
      vs_cpu.memory = DumbVM::Memory.from_array(initial_memory.dup)
    end
  end

  it 'extends DumbVM::DSL' do
    expect(described_class).to be_a(DumbVM::DSL)
  end

  describe '#iw' do
    subject(:iw) { vs_cpu.iw }

    it_behaves_like 'a register', size: 32
  end

  describe '#pc' do
    subject(:pc) { vs_cpu.pc }

    it_behaves_like 'a register', size: 14

    it { is_expected.to be_zero }
  end

  describe '#r1' do
    subject(:r1) { vs_cpu.r1 }

    it_behaves_like 'a register', size: 32
  end

  describe '#r2' do
    subject(:r2) { vs_cpu.r2 }

    it_behaves_like 'a register', size: 32
  end

  describe '#fetch' do
    before { pending('Not implemented') }

    context 'with an instruction on memory' do
      include_context 'with an initialized memory'

      let(:instruction_word) { VerySimpleCPU::InstructionWord.new(opcode: 0b111, im: 1, a: 0x3CCC, b: 0x3FFF) }
      let(:initial_memory) { instruction_word.to_a }

      it 'fetches the value defined by #pc to #iw' do
        expect { vs_cpu.fetch }.to change(vs_cpu, :iw).from(0).to(instruction_word.to_i)
      end
    end

    it 'raises an exception when no memory is set' do
      expect { vs_cpu.fetch }.to raise_exception(DumbVM::InvalidStateException, /Memory not set/)
    end
  end

  describe '#decode' do
    before { pending('Not implemented') }

    context 'when the instruction word is for the ADD operation' do
      before { vs_cpu.iw <= VerySimpleCPU::InstructionWord.new(opcode: 0b000, im: 1).to_i }

      it 'returns :ADD' do
        expect(vs_cpu.decode).to be(:ADD)
      end
    end

    context 'when the instruction word is for the ADDi operation' do
      before { vs_cpu.iw <= VerySimpleCPU::InstructionWord.new(opcode: 0b000, im: 1).to_i }

      it 'returns :ADDi' do
        expect(vs_cpu.decode).to be(:ADDi)
      end
    end

    context 'when the instruction word is for the CP operation' do
      before { vs_cpu.iw <= VerySimpleCPU::InstructionWord.new(opcode: 0b100, im: 0).to_i }

      it 'returns :CP' do
        expect(vs_cpu.decode).to be(:CP)
      end
    end

    context 'when the instruction word is for the CPi operation' do
      before { vs_cpu.iw <= VerySimpleCPU::InstructionWord.new(opcode: 0b100, im: 1).to_i }

      it 'returns :CPi' do
        expect(vs_cpu.decode).to be(:CPi)
      end
    end

    context 'when the instruction word is for the BZJ operation' do
      before { vs_cpu.iw <= VerySimpleCPU::InstructionWord.new(opcode: 0b110, im: 0).to_i }

      it 'returns :BZJ' do
        expect(vs_cpu.decode).to be(:BZJ)
      end
    end

    context 'when the instruction word is for the BZJi operation' do
      before { vs_cpu.iw <= VerySimpleCPU::InstructionWord.new(opcode: 0b110, im: 1).to_i }

      it 'returns :BZJi' do
        expect(vs_cpu.decode).to be(:BZJi)
      end
    end
  end

  describe '#cycle' do
    before { pending('Not implemented') }

    context 'when the next instruction is an ADD instruction' do
      include_context 'with an initialized memory'

      let(:initial_memory) do
        [
          instruction_word.to_i, # 0x00
          0x04030201,            # 0x04
          0x0D0C0B0A             # 0x08
        ].map { |n| DumbVM.to_byte_array(n) }.flatten.freeze
      end
      let(:instruction_word) { VerySimpleCPU::InstructionWord.new(opcode: 0b000, im: 0, a: 0x0004, b: 0x0008) }

      it 'executes the ADD instruction' do
        expected_output = initial_memory.dup
        expected_output[0x04..0x07] = DumbVM.to_byte_array(0x04030201 + 0x0D0C0B0A)

        expect { vs_cpu.cycle }.to change { vs_cpu.memory.content }.from(initial_memory).to(expected_output)
      end

      it 'sets the instruction word' do
        expect { vs_cpu.cycle }.to change(vs_cpu, :iw).from(0x00000000).to(instruction_word.to_i)
      end

      it 'increases the program counter' do
        expect { vs_cpu.cycle }.to change(vs_cpu, :pc).from(0x0000).to(0x0001)
      end

      it 'sets the value for register 1' do
        expect { vs_cpu.cycle }.to change(vs_cpu, :r1).from(0x00000000).to(0x04030201)
      end

      it 'sets the value for register 2' do
        expect { vs_cpu.cycle }.to change(vs_cpu, :r2).from(0x00000000).to(0x0D0C0B0A)
      end
    end

    context 'when the next instruction is an ADDi instruction' do
      include_context 'with an initialized memory'

      let(:initial_memory) do
        [
          instruction_word.to_i, # 0x00
          0x04030201             # 0x04
        ].map { |n| DumbVM.to_byte_array(n) }.flatten.freeze
      end
      let(:instruction_word) { VerySimpleCPU::InstructionWord.new(opcode: 0b000, im: 1, a: 0x0004, b: 0x2AAA) }

      it 'executes the ADDi instruction' do
        expected_output = program.dup
        expected_output[0x04..0x07] = DumbVM.to_byte_array(0x4032CAB)

        expect { vs_cpu.cycle }.to change { vs_cpu.memory.content }.from(program).to(expected_output)
      end

      it 'sets the instruction word' do
        expect { vs_cpu.cycle }.to change(vs_cpu, :iw).from(0x00000000).to(instruction_word.to_i)
      end

      it 'increases the program counter' do
        expect { vs_cpu.cycle }.to change(vs_cpu, :pc).from(0x0000).to(0x0001)
      end

      it 'sets the value for register 1' do
        expect { vs_cpu.cycle }.to change(vs_cpu, :r1).from(0x00000000).to(0x04030201)
      end

      it 'sets the value for register 2' do
        expect { vs_cpu.cycle }.to change(vs_cpu, :r2).from(0x00000000).to(0x00002AAA)
      end
    end

    context 'when the next instruction is a CP instruction' do
      include_context 'with an initialized memory'

      let(:initial_memory) do
        [
          instruction_word.to_i, # 0x00
          0x00000000,            # 0x04
          0x87654321             # 0x08
        ].map { |n| DumbVM.to_byte_array(n) }.flatten.freeze
      end
      let(:instruction_word) { VerySimpleCPU::InstructionWord.new(opcode: 0b100, im: 0, a: 0x0004, b: 0x0008) }

      it 'executes the CP instruction' do
        expected_output = program.dup
        expected_output[0x08..0x0B] = DumbVM.to_byte_array(0x87654321)

        expect { vs_cpu.cycle }.to change { vs_cpu.memory.content }.from(program).to(expected_output)
      end

      it 'sets the instruction word' do
        expect { vs_cpu.cycle }.to change(vs_cpu, :iw).from(0x00000000).to(instruction_word.to_i)
      end

      it 'increases the program counter' do
        expect { vs_cpu.cycle }.to change(vs_cpu, :pc).from(0x0000).to(0x0001)
      end

      it 'does not set the value for register 1' do
        expect { vs_cpu.cycle }.not_to change(vs_cpu, :r1)
      end

      it 'sets the value for register 2' do
        expect { vs_cpu.cycle }.to change(vs_cpu, :r2).from(0x00000000).to(0x87654321)
      end
    end

    context 'when the next instruction is a CPi instruction' do
      include_context 'with an initialized memory'

      let(:initial_memory) do
        [
          instruction_word.to_i, # 0x00
          0x00000000             # 0x04
        ].map { |n| DumbVM.to_byte_array(n) }.flatten.freeze
      end
      let(:instruction_word) { VerySimpleCPU::InstructionWord.new(opcode: 0b100, im: 1, a: 0x0004, b: 0x2BCD) }

      it 'executes the CPi instruction' do
        expected_output = program.dup
        expected_output[0x08..0x0B] = DumbVM.to_byte_array(0x00002BCD)

        expect { vs_cpu.cycle }.to change { vs_cpu.memory.content }.from(program).to(expected_output)
      end

      it 'sets the instruction word' do
        expect { vs_cpu.cycle }.to change(vs_cpu, :iw).from(0x00000000).to(instruction_word.to_i)
      end

      it 'increases the program counter' do
        expect { vs_cpu.cycle }.to change(vs_cpu, :pc).from(0x0000).to(0x0001)
      end

      it 'does not set the value for register 1' do
        expect { vs_cpu.cycle }.not_to change(vs_cpu, :r1)
      end

      it 'sets the value for register 2' do
        expect { vs_cpu.cycle }.to change(vs_cpu, :r2).from(0x00000000).to(0x00002BCD)
      end
    end

    context 'when the next instruction is a BZJ instruction and the jump should be made' do
      include_context 'with an initialized memory'

      let(:initial_memory) do
        [
          instruction_word.to_i, # 0x00
          0x00001234,            # 0x04
          0x00000000             # 0x08
        ].map { |n| DumbVM.to_byte_array(n) }.flatten.freeze
      end
      let(:instruction_word) { VerySimpleCPU::InstructionWord.new(opcode: 0b110, im: 0, a: 0x0004, b: 0x0008) }

      it 'does not update the memory' do
        expect { vs_cpu.cycle }.not_to(change { vs_cpu.memory.content })
      end

      it 'sets the instruction word' do
        expect { vs_cpu.cycle }.to change(vs_cpu, :iw).from(0x00000000).to(instruction_word.to_i)
      end

      it 'sets the program counter' do
        expect { vs_cpu.cycle }.to change(vs_cpu, :pc).from(0x0000).to(0x1234)
      end

      it 'sets the value for register 1' do
        expect { vs_cpu.cycle }.to change(vs_cpu, :r1).from(0x00000000).to(0x12345678)
      end

      it 'sets the value for register 2' do
        expect { vs_cpu.cycle }.to change(vs_cpu, :r2).from(0x00000000).to(0x00000000)
      end
    end

    context 'when the next instruction is a BZJ instruction and the jump should not be made' do
      include_context 'with an initialized memory'

      let(:initial_memory) do
        [
          instruction_word.to_i, # 0x00
          0x00001234,            # 0x04
          0x00000001             # 0x08
        ].map { |n| DumbVM.to_byte_array(n) }.flatten.freeze
      end
      let(:instruction_word) { VerySimpleCPU::InstructionWord.new(opcode: 0b110, im: 0, a: 0x0004, b: 0x0008) }

      it 'does not update the memory' do
        expect { vs_cpu.cycle }.not_to(change { vs_cpu.memory.content })
      end

      it 'sets the instruction word' do
        expect { vs_cpu.cycle }.to change(vs_cpu, :iw).from(0x00000000).to(instruction_word.to_i)
      end

      it 'increases the program counter' do
        expect { vs_cpu.cycle }.to change(vs_cpu, :pc).from(0x0000).to(0x0001)
      end

      it 'sets the value for register 1' do
        expect { vs_cpu.cycle }.to change(vs_cpu, :r1).from(0x00000000).to(0x12345678)
      end

      it 'sets the value for register 2' do
        expect { vs_cpu.cycle }.to change(vs_cpu, :r2).from(0x00000000).to(0x00000001)
      end
    end

    context 'with a BZJi instruction' do
      include_context 'with an initialized memory'

      let(:initial_memory) do
        [
          instruction_word.to_i, # 0x00
          0x00001234             # 0x04
        ].map { |n| DumbVM.to_byte_array(n) }.flatten.freeze
      end
      let(:instruction_word) { VerySimpleCPU::InstructionWord.new(opcode: 0b110, im: 1, a: 0x0004, b: 0x0765) }

      it 'does not update the memory' do
        expect { vs_cpu.cycle }.not_to(change { vs_cpu.memory.content })
      end

      it 'sets the instruction word' do
        expect { vs_cpu.cycle }.to change(vs_cpu, :iw).from(0x00000000).to(instruction_word.to_i)
      end

      it 'sets the program counter' do
        expect { vs_cpu.cycle }.to change(vs_cpu, :pc).from(0x0000).to(0x1999)
      end

      it 'sets the value for register 1' do
        expect { vs_cpu.cycle }.to change(vs_cpu, :r1).from(0x00000000).to(0xABCD8765)
      end

      it 'sets the value for register 2' do
        expect { vs_cpu.cycle }.to change(vs_cpu, :r2).from(0x00000000).to(0x00001234)
      end
    end
  end
end
