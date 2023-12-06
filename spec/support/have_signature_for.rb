# frozen_string_literal: true
# typed: strong

class HaveSignatureFor # rubocop:disable Metrics/ClassLength
  extend T::Sig

  sig { params(method_name: Symbol).void }
  def initialize(method_name)
    @method_name = method_name
    @actual_definition = T.let(nil, T.nilable(T::Private::Methods::Signature))
    @expected_return_type = T.let(nil, T.nilable(T::Types::Base))
    @expected_params = T.let(nil, T.nilable(T::Hash[Symbol, T::Types::Base]))
  end

  sig { returns(String) }
  def description
    "have method ##{@method_name} with #{expected_sig_description}"
  end

  sig { params(object: Object).returns(T::Boolean) }
  def matches?(object)
    read_method_signature(object)

    has_signature? && has_expected_params? && has_expected_return_type?
  end

  sig { returns(String) }
  def failure_message
    "expected method ##{@method_name} to have #{expected_sig_description} " \
      "but #{actual_sig_description} was found"
  end

  sig { returns(String) }
  def failure_message_when_negated
    "expected method ##{@method_name} not to have #{expected_sig_description}"
  end

  sig do
    params(params: T::Hash[Symbol, T.any(Module, T::Types::Base)])
      .returns(HaveSignatureFor)
  end
  def with_params(params)
    raise 'params cannot be empty' if params.empty?

    @expected_params = params.transform_values { |type| coerce(type) }

    self
  end

  sig { returns(HaveSignatureFor) }
  def without_params
    @expected_params = {}

    self
  end

  sig { params(return_type: T.any(Module, T::Types::Base)).returns(HaveSignatureFor) }
  def with_return_type(return_type)
    @expected_return_type = coerce(return_type)

    self
  end

  sig { returns(HaveSignatureFor) }
  def without_return_type
    @expected_return_type = void_type

    self
  end

  private

  sig { params(type: T.any(Module, T::Types::Base)).returns(T::Types::Base) }
  def coerce(type)
    return type if type.is_a?(T::Types::Base)

    T::Utils.coerce(type)
  end

  sig { params(object: Object).void }
  def read_method_signature(object)
    return unless object.respond_to?(@method_name)

    @actual_definition = T::Utils.signature_for_method(object.method(@method_name))
  end

  sig { returns(T::Boolean) }
  def has_signature? = !@actual_definition.nil?

  sig { returns(T::Boolean) }
  def has_expected_params?
    return true unless @expected_params

    actual_params == @expected_params
  end

  sig { returns(T::Boolean) }
  def has_expected_return_type?
    return true unless @expected_return_type

    T.must(@actual_definition).return_type == @expected_return_type
  end

  sig { returns(T.nilable(T::Hash[Symbol, T::Types::Base])) }
  def actual_params
    @actual_definition&.arg_types
                      &.to_h
                      &.transform_values { |type| T::Utils.coerce(type) }
  end

  sig { returns(String) }
  def expected_sig_description
    "sig { #{sig_description(@expected_params, @expected_return_type)} }"
  end

  sig { returns(String) }
  def actual_sig_description
    return 'none' unless @actual_definition

    # Have to calculate the description for the actual signature based on the
    # expected signature, hence the ternary operators
    sig = sig_description(
      @expected_params.nil? ? nil : actual_params,
      @expected_return_type.nil? ? nil : @actual_definition.return_type
    )

    "sig { #{sig} }"
  end

  sig do
    params(
      params: T.nilable(T::Hash[Symbol, T::Types::Base]),
      return_type: T.nilable(T::Types::Base)
    ).returns(String)
  end
  def sig_description(params, return_type)
    # This whole '.', '..' and '.....' is a convoluted way to ensure we have only
    # 3 dots when nothing is expected (ex: `...void`) or a single dot at the
    # middle of the signature (ex: `params(arg: Symbol).void`)
    description = [
      params_description(params) || '..',
      return_type_description(return_type) || '..'
    ].join('.')

    return '...' if description == '.....'

    description
  end

  sig { params(params: T.nilable(T::Hash[Symbol, T::Types::Base])).returns(T.nilable(String)) }
  def params_description(params)
    return nil if params.nil?

    "params(#{params.map { |name, type| "#{name}: #{type}" }.join(', ')})"
  end

  sig { params(return_type: T.nilable(T::Types::Base)).returns(T.nilable(String)) }
  def return_type_description(return_type)
    return nil if return_type.nil?
    return 'void' if return_type == void_type

    "returns(#{return_type})"
  end

  sig { returns(T::Types::Base) }
  def void_type = T::Utils.signature_for_method(method(:method_with_void_return_type)).return_type

  sig { void }
  def method_with_void_return_type; end
end

T::Sig::WithoutRuntime.sig { params(method_name: Symbol).returns(HaveSignatureFor) }
def have_signature_for(method_name)
  HaveSignatureFor.new(method_name)
end
