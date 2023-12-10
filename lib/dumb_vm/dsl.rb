# frozen_string_literal: true
# typed: strong

module DumbVM
  # This module is the main DSL to describe a VM within a class. The correct way to use it is as follows:
  #
  # ```
  # class MyCPU
  #   register :program_counter, size: bits(8), init_value: 0
  #   register :instruction, size: bits(32)
  #
  #   fetch { instruction <= memory.read_bits(32, offset: program_counter) }
  # end
  # ```
  module DSL
    extend T::Sig

    sig { params(other: Module).void }
    # @!visibility private
    def self.extended(other)
      other.extend(T::Sig) unless other.is_a?(T::Sig)

      other.class_eval <<-CLASS, __FILE__, __LINE__ + 1
        sig { returns(T.nilable(Memory)) }
        # !attribute [rw] memory
        #   @return [Memory] The memory for the VM
        attr_reader :memory

        sig { params(memory: T.nilable(Memory)).returns(T.nilable(Memory)) }
        # @!visibility private
        def memory=(memory)
          @memory = memory
        end
      CLASS
    end

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
      T.bind(self, T::Class[T.anything])

      send(:sig) { T.cast(self, T::Private::Methods::DeclBuilder).returns(Register) }
      define_method(name) do
        return instance_variable_get("@#{name}") if instance_variable_defined?("@#{name}")

        register = Register.new(size)
        register <= init_value if init_value

        instance_variable_set("@#{name}", register)
      end
    end

    sig { params(count: Integer).returns(BitLength) }
    def bits(count)
      BitLength.new(count)
    end

    sig { params(block: T.proc.void).void }
    def fetch(&block)
      T.bind(self, T::Class[T.anything])

      # Cast the block so it can be passed to `instance_exec` later
      typed_block = T.cast(block, T.proc.params(_: T.untyped).returns(T.anything))

      send(:sig) { T.cast(self, T::Private::Methods::DeclBuilder).void }
      define_method(:fetch) { instance_exec(&typed_block) }
    end

    sig { void }
    def decode; end

    sig { params(name: Symbol).void }
    def operation(name); end
  end
end
