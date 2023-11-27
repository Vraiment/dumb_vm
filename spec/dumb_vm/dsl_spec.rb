# frozen_string_literal: true

require 'dumb_vm'

RSpec.describe DumbVM::DSL do
  subject(:vm_class) { Class.new { extend DumbVM::DSL } }

  describe '#register' do
    context 'when a register is defined' do
      subject(:instance) { vm_class.new }

      before { vm_class.register :my_register, size: DumbVM::BitLength.bits(8) }

      it 'defines a register with the given size', :aggregate_failures do
        expect(instance).to respond_to(:my_register)
        expect(instance.my_register).to be_a(DumbVM::Register)
        expect(instance.my_register).to have_attributes(size: DumbVM::BitLength.bits(8))
      end
    end

    context 'when a register is defined with an initial value' do
      subject(:instance) { vm_class.new }

      before { vm_class.register :my_register, size: DumbVM::BitLength.bits(8), init_value: 15 }

      it 'defines a register with the given size', :aggregate_failures do
        expect(instance).to respond_to(:my_register)
        expect(instance.my_register).to be_a(DumbVM::Register)
        expect(instance.my_register).to have_attributes(size: DumbVM::BitLength.bits(8),
                                                        value: 15)
      end
    end
  end
end
