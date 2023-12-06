# frozen_string_literal: true

require 'dumb_vm'

RSpec.describe DumbVM::Memory do
  describe '.from_array' do
    it 'creates an instance of DumbVM::Memory::ArrayBased' do
      instance = instance_double(DumbVM::Memory::ArrayBased)
      array = [0x00, 0x01, 0x02]
      allow(DumbVM::Memory::ArrayBased).to receive(:new).with(array).and_return(instance)

      expect(described_class.from_array(array)).to eq(instance)
    end
  end
end
