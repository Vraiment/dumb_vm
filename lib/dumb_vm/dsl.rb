# frozen_string_literal: true
# typed: strong

module DumbVM
  # This module is the main DSL to describe a VM within a class. The correct way to use it is as follows:
  #
  # ```
  # class MyCPU
  #   register :program_counter, size: bits(8), init_value: 0
  #   register :instruction, size: bits(32)
  # end
  # ```
  module DSL
    extend T::Sig

    sig { params(name: Symbol, size: BitLength, init_value: T.nilable(Integer)).void }
    # Declares a new register with the given `name`
    #
    # This register will be accessible as a readonly attribute that returns an
    # instance of {Register}
    #
    # @param name [Symbol] The name of the register
    # @param size [BitLength] The size of the register
    # @param init_value [Integer, nil] The initial value of the register
    #
    # @return [Void]
    def register(name, size:, init_value: nil)
      # This is to make Sorbet happy, it will complaint just calling class methods
      # so we "let" the module be "untyped" (which means a dynamic value for Sorbet)
      # and then cast it to a `Class` object (of type anything)
      clazz = T.cast(T.let(self, T.untyped), T::Class[T.anything])

      clazz.define_method(name) do
        unless clazz.instance_variable_defined?("@#{name}")
          register = Register.new(size)
          register <= init_value if init_value

          clazz.instance_variable_set("@#{name}", register)
        end

        clazz.instance_variable_get("@#{name}")
      end
    end

    sig { params(count: Integer).returns(BitLength) }
    def bits(count)
      BitLength.new(count)
    end

    sig { void }
    def fetch; end

    sig { void }
    def decode; end

    sig { params(name: Symbol).void }
    def operation(name); end
  end
end
