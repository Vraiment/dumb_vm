# frozen_string_literal: true

require_relative '../../support/very_simple_cpu/instruction_word'

RSpec.describe VerySimpleCPU::InstructionWord do
  subject(:instruction_word) { described_class.new(opcode:, im:, a:, b:) }

  let(:opcode) { 0b101 }
  let(:im) { 0b1 }
  let(:a) { 0b10101010101010 }
  let(:b) { 0b01010101010101 }

  it { is_expected.to have_attributes(opcode:, im:, a:, b:) }

  describe '.new' do
    context 'with a negative opcode' do
      let(:opcode) { -1 }

      it 'raises an error' do
        expect { instruction_word }.to raise_exception(/Invalid opcode/)
      end
    end

    context 'with an opcode higher than 3 bits' do
      let(:opcode) { 0b1000 }

      it 'raises an error' do
        expect { instruction_word }.to raise_exception(/Invalid opcode/)
      end
    end

    context 'with a negative "im" value' do
      let(:im) { -1 }

      it 'raises an error' do
        expect { instruction_word }.to raise_exception(/Invalid im/)
      end
    end

    context 'with an "im" value higher than 1 bit' do
      let(:im) { 0b10 }

      it 'raises an error' do
        expect { instruction_word }.to raise_exception(/Invalid im/)
      end
    end

    context 'with a negative "a" value' do
      let(:a) { -1 }

      it 'raises an error' do
        expect { instruction_word }.to raise_exception(/Invalid a/)
      end
    end

    context 'with an "a" value higher than 14 bits' do
      let(:a) { 1 << 15 }

      it 'raises an error' do
        expect { instruction_word }.to raise_exception(/Invalid a/)
      end
    end

    context 'with a negative "b" value' do
      let(:b) { -1 }

      it 'raises an error' do
        expect { instruction_word }.to raise_exception(/Invalid b/)
      end
    end

    context 'with an "b" value higher than 14 bits' do
      let(:b) { 1 << 15 }

      it 'raises an error' do
        expect { instruction_word }.to raise_exception(/Invalid b/)
      end
    end
  end

  describe '#to_a' do
    it 'converts the values to a byte array' do
      expect(instruction_word.to_a).to contain_exactly(0x55, 0x95, 0xAA, 0xBA)
    end
  end

  describe '#to_i' do
    it 'converts the values to a single integer that has the opcode on bit 29' do
      expect((instruction_word.to_i >> 29) & 0b111).to be(opcode)
    end

    it 'converts the values to a single integer that has the im value on bit 28' do
      expect((instruction_word.to_i >> 28) & 0b1).to be(im)
    end

    it 'converts the values to a single integer that has the a value on bit 14' do
      expect((instruction_word.to_i >> 14) & 0b11111111111111).to be(a)
    end

    it 'converts the values to a single integer that has the b value on bit 0' do
      expect(instruction_word.to_i & 0b11111111111111).to be(b)
    end

    it 'converts the values to a single integer' do
      expect(instruction_word.to_i).to be(0xBAAA9555)
    end
  end

  describe '#to_s' do
    it 'converts the value to a string' do
      expect(instruction_word.to_s).to eq('{:opcode=>0b101, :im=>1, :a=>0x2AAA, :b=>0x1555}')
    end
  end
end
