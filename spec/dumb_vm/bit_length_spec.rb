# frozen_string_literal: true

RSpec.describe DumbVM::BitLength do
  subject(:bit_length) { described_class.new(0) }

  it { is_expected.to have_attributes(bits: 0, bytes: 0) }

  describe '.new' do
    context 'when the bits are not a multitple of 4' do
      subject(:bit_length) { described_class.new(13) }

      it 'rounds up the amount of bytes' do
        expect(bit_length).to have_attributes(bits: 13, bytes: 2)
      end
    end

    context 'when the size is negative' do
      subject(:bit_length) { described_class.new(-1) }

      it 'raises an exception' do
        expect { bit_length }.to raise_exception(DumbVM::Error, /The amount of bits is negative/)
      end
    end
  end

  describe '#==' do
    it 'returns true if the other has the same length' do
      expect(bit_length == described_class.new(0)).to be(true)
    end

    it 'returns false if the other has a different length' do
      expect(bit_length == described_class.new(1)).to be(false)
    end

    it 'returns false if the other is not a BitLength' do
      expect(bit_length == 'A String').to be(false)
    end

    it 'returns false if the other is nil' do
      expect(bit_length == nil).to be(false) # rubocop:disable Style/NilComparison
    end
  end

  describe '#!+' do
    it 'returns false if the other has the same length' do
      expect(bit_length != described_class.new(0)).to be(false)
    end

    it 'returns true if the other has a different length' do
      expect(bit_length != described_class.new(1)).to be(true)
    end

    it 'returns true if the other is not a BitLength' do
      expect(bit_length != 'A String').to be(true)
    end

    it 'returns true if the other is nil' do
      expect(bit_length != nil).to be(true) # rubocop:disable Style/NonNilCheck
    end
  end

  describe '.bits' do
    it 'creates a bit length with the given amount of bits', :aggregate_failures do
      bit_length = described_class.bits(32)

      expect(bit_length.bits).to be(32)
      expect(bit_length.bytes).to be(4)
    end
  end

  describe '#to_s' do
    it 'converts the value to a string' do
      expect(bit_length.to_s).to eq('{:bits=>0, :bytes=>0}')
    end

    context 'with a non zero amount' do
      subject(:bit_length) { described_class.new(8) }

      it 'converts the value to a string' do
        expect(bit_length.to_s).to eq('{:bits=>8, :bytes=>1}')
      end
    end
  end
end
