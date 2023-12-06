# frozen_string_literal: true
# typed: strong

module DumbVM
  module Memory
    # Class to represent a memory that store its contents on an Array. Good for simple testing and debugging
    class ArrayBased
      extend T::Sig

      include Memory

      sig { params(array: T::Array[Integer]).void }
      # Creates a new instance from the contents of the array
      #
      # @param array [Array<Integer>] The contents of the memory
      def initialize(array)
        @array = array
      end
    end
  end
end
