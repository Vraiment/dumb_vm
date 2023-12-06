# frozen_string_literal: true
# typed: strong

module DumbVM
  # Interface with memory definitions for use on the VMs and some useful factory methods
  module Memory
    extend T::Sig
    extend T::Helpers

    interface!

    sig { params(array: T::Array[Integer]).returns(ArrayBased) }
    # Creates a new instance of {ArrayBased} with the given `array`
    #
    # @param array [Array<Integer>] The array of bytes with the contents of the memory
    #
    # @return [ArrayBased] A new instance of {ArrayBased}
    def self.from_array(array) = ArrayBased.new(array)
  end
end
