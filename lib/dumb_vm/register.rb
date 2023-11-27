# frozen_string_literal: true
# typed: strong

module DumbVM
  # Class to represent a register on a CPU
  class Register
    extend T::Sig

    sig { params(size: BitLength).void }
    # Initializes a {Register} with the given size
    #
    # @param size [BitLength] The size of the register
    def initialize(size)
      @size = size
      @value = T.let(0, Integer)
    end

    sig { returns(BitLength) }
    # The size of the register
    #
    # @return [BitLength] The size of the register
    attr_reader :size

    sig { returns(Integer) }
    # The value on the register
    #
    # @return [Integer] The value of the register
    attr_reader :value

    sig { params(value: Integer).returns(Integer) }
    # Sets the value of the register
    #
    # @param value [Integer] The new value for the register
    #
    # @return [Integer] The assigned value
    def <=(value) = @value = value # rubocop:disable Naming/BinaryOperatorParameterName This is not a binary operator

    sig { returns(T::Boolean) }
    # Checks if the value of the register is zero
    #
    # @return [Boolean] True if the value of the register is zero, false otherwise
    def zero? = value.zero?
  end
end
