# frozen_string_literal: true
# typed: strong

require 'sorbet-runtime'

class VerySimpleCPU
  # Class to represent an instruction word
  class InstructionWord
    extend T::Sig

    sig do
      params(
        opcode: T.any(Integer, NilClass),
        im: T.any(Integer, NilClass),
        a: T.any(Integer, NilClass),
        b: T.any(Integer, NilClass)
      ).void
    end
    def initialize(opcode: nil, im: nil, a: nil, b: nil) # rubocop:disable Naming/MethodParameterName
      @opcode = T.let(opcode || 0, Integer)
      @im = T.let(im || 0, Integer)
      @a = T.let(a || 0, Integer)
      @b = T.let(b || 0, Integer)

      validate!
    end

    sig { returns(Integer) }
    attr_reader :opcode, :im, :a, :b

    sig { returns(T::Array[Integer]) }
    def to_a = T.let([to_i].pack('L'), String).bytes

    sig { returns(Integer) }
    def to_i = (opcode << 29) | (im << 28) | (a << 14) | b

    sig { returns(String) }
    def to_s
      { opcode: "0b#{opcode.to_s(2)}", im:, a: "0x#{a.to_s(16).upcase}", b: "0x#{b.to_s(16).upcase}" }
        .to_s
        .gsub('"', '') # Just remove the double quotes from the "stringified" values
    end

    private

    sig { void }
    def validate!
      raise 'Invalid opcode' unless valid_value?(value: opcode, size: 3)
      raise 'Invalid im' unless valid_value?(value: im, size: 1)
      raise 'Invalid a' unless valid_value?(value: a, size: 14)
      raise 'Invalid b' unless valid_value?(value: b, size: 14)
    end

    sig { params(value: Integer, size: Integer).returns(T::Boolean) }
    def valid_value?(value:, size:) = !value.negative? && value <= ((1 << size) - 1)
  end
end
