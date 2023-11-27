# frozen_string_literal: true
# typed: strong

module DumbVM
  # Class to represent a bit length
  class BitLength
    extend T::Sig

    sig { params(bits: Integer).void }
    # Initializes a {BitLength}
    #
    # @param bits [Integer] The amount of bits for the length
    def initialize(bits)
      raise Error, 'The amount of bits is negative' if bits.negative?

      @bits = bits
      @bytes = T.let(bits / 8, Integer)
      # Add an extra byte if is not a multiple of 8. The assigment above
      # (bits / 8) will yield an Integer, if we devide two `BigDecimal` numbers
      # it will yield a decimal value. If the decimal and integer are the same
      # that means `bytes` is a multitple of 8, otherwise we need to add an
      # an extra byte to account for the rest of the bits
      @bytes += 1 unless @bytes == (BigDecimal(bits) / BigDecimal(8))
    end

    sig { returns(Integer) }
    # Returns the length
    #
    # @return [Integer] The actual length (ie: the amount of bits)
    attr_reader :bits

    sig { returns(Integer) }
    # Returns the amount of bytes (8 bits) required to hold this amount of bits
    #
    # @return [Integer] The amount of bytes (8 bits)
    attr_reader :bytes

    sig { params(count: Integer).returns(BitLength) }
    # Creates a new instance of {BitLength} with the given amount of bits
    #
    # @param count [Integer] The amount of bits for the length
    #
    # @return [BitLength] The new {BitLength} instance
    def self.bits(count) = new(count)

    sig { params(other: T.untyped).returns(T::Boolean) }
    # Compares this {BitLength} against another object
    #
    # @param other [Object] The object to compare against
    #
    # @return [Boolean] True if both are a {BitLength} and have the same amount of bits
    def ==(other) = T.cast(other, Object).is_a?(BitLength) && T.cast(other, BitLength).bits == bits
  end
end
