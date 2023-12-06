# frozen_string_literal: true

require 'dumb_vm'

require_relative '../support/have_signature_for'

RSpec.describe DumbVM::DSL do
  subject(:vm_class) { Class.new { extend DumbVM::DSL } }

  let(:instance) { vm_class.new }

  describe '#register' do
    context 'when a register is defined' do
      before { vm_class.register :my_register, size: DumbVM::BitLength.bits(8) }

      it 'defines a register with the given size', :aggregate_failures do
        expect(instance).to respond_to(:my_register)
        expect(instance.my_register).to be_a(DumbVM::Register)
        expect(instance.my_register).to have_attributes(size: DumbVM::BitLength.bits(8))
      end
    end

    context 'when a register is defined with an initial value' do
      before { vm_class.register :my_register, size: DumbVM::BitLength.bits(8), init_value: 15 }

      it 'defines a register with the given size', :aggregate_failures do
        expect(instance).to respond_to(:my_register)
        expect(instance.my_register).to be_a(DumbVM::Register)
        expect(instance.my_register).to have_attributes(size: DumbVM::BitLength.bits(8),
                                                        value: 15)
      end
    end
  end

  describe '#fetch' do
    it 'defines a #fetch method' do
      vm_class.fetch {} # rubocop:disable Lint/EmptyBlock

      expect(instance).to respond_to(:fetch)
    end

    it 'defines a #fetch method that calls the given block' do
      block_called = false
      vm_class.fetch { block_called = true }

      expect { instance.fetch }.to change { block_called }.from(false).to(true)
    end

    it 'defines a #fetch method that calls the given block on the context of the class' do
      vm_class.define_method(:value) { instance_variable_get('@value') }
      vm_class.define_method(:value=) { |value| instance_variable_set('@value', value) }
      vm_class.fetch { self.value = :called }

      expect { instance.fetch }.to change(instance, :value).from(nil).to(:called)
    end
  end

  describe '.extended' do
    it 'defines a #memory accessor with the correct signature' do
      expect(instance).to have_signature_for(:memory)
        .without_params
        .with_return_type(T.nilable(DumbVM::Memory))
    end

    it 'defines a #memory that returns the value of the instance variable', :aggregate_failures do
      expect(instance).to respond_to(:memory)

      memory = instance_double(DumbVM::Memory)
      instance.instance_variable_set(:@memory, memory)

      expect(instance.memory).to be(memory)
    end

    it 'defines a #memory= accessor with the correct signature' do
      expect(instance).to have_signature_for(:memory=)
        .with_params(memory: T.nilable(DumbVM::Memory))
        .with_return_type(T.nilable(DumbVM::Memory))
    end

    it 'defines a #memory= accessor that sets and returns the value of the instance variable', :aggregate_failures do
      expect(instance).to respond_to(:memory=)

      memory = instance_double(DumbVM::Memory)

      expect { expect(instance.memory = memory).to be(memory) }
        .to change { instance.instance_variable_get(:@memory) }.from(nil).to(memory)
    end
  end
end
