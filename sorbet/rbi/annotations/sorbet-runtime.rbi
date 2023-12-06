# typed: true

module T
  module Types
    class Base
      sig { params(other: Object).returns(T::Boolean) }
      def ==(other); end
    end

    class Simple
      sig { returns(T::Class[T.anything]) }
      def raw_type; end
    end
  end

  module Private
    module Methods
      class Signature
        sig { returns(T::Array[[Symbol, T::Types::Base]]) }
        attr_reader :arg_types

        sig { returns(T::Types::Base) }
        attr_reader :return_type
      end
    end
  end

  module Utils
    sig { params(method: Method).returns(::T::Private::Methods::Signature) }
    def self.signature_for_method(method); end
  end
end
