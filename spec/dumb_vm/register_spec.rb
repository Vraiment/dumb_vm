# frozen_string_literal: true

RSpec.describe DumbVM::Register do
  subject(:register) { described_class.new(size) }

  let(:size) { DumbVM::BitLength.bits(32) }

  it { is_expected.to have_attributes(size:, value: 0) }

  describe '#<=' do
    it 'assigns the value of the register to the given integer' do
      expect { register <= 253 }.to change(register, :value).from(0).to(253)
    end

    it 'returns the assigned value' do
      expect(register <= 123).to be(123)
    end
  end

  describe '#zero?' do
    context 'when the value of the register is 0' do
      before { register <= 0 }

      it 'returns true' do
        expect(register.zero?).to be(true)
      end
    end

    context 'when the value of the register is not 0' do
      before { register <= 1 }

      it 'returns false' do
        expect(register.zero?).to be(false)
      end
    end
  end
end
