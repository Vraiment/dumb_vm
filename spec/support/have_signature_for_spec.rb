# frozen_string_literal: true
# typed: false

require_relative 'have_signature_for'

# THe rest of the tests for this class are on the `method_have_signature_for_spec.rb` file
RSpec.describe HaveSignatureFor do
  subject(:matcher) { described_class.new(method_name) }

  let(:method_name) { :a_method }

  describe '#description' do
    subject(:description) { matcher.description }

    it { is_expected.to eq('have method #a_method with sig { ... }') }

    context 'when a param list is set' do
      before { matcher.with_params(a: String, b: Integer) }

      it { is_expected.to eq('have method #a_method with sig { params(a: String, b: Integer)... }') }
    end

    context 'when a no param list is empty' do
      before { matcher.without_params }

      it { is_expected.to eq('have method #a_method with sig { params()... }') }
    end

    context 'when a return type is set' do
      before { matcher.with_return_type(Symbol) }

      it { is_expected.to eq('have method #a_method with sig { ...returns(Symbol) }') }
    end

    context 'when the return type is void' do
      before { matcher.without_return_type }

      it { is_expected.to eq('have method #a_method with sig { ...void }') }
    end

    context 'when a param list and return type are set' do
      before { matcher.with_params(a: String, b: Integer).with_return_type(Symbol) }

      it { is_expected.to eq('have method #a_method with sig { params(a: String, b: Integer).returns(Symbol) }') }
    end

    context 'when a param list and no return type are set' do
      before { matcher.with_params(a: String, b: Integer).without_return_type }

      it { is_expected.to eq('have method #a_method with sig { params(a: String, b: Integer).void }') }
    end

    context 'when an empty param list and return type are set' do
      before { matcher.without_params.with_return_type(Symbol) }

      it { is_expected.to eq('have method #a_method with sig { params().returns(Symbol) }') }
    end

    context 'when an empty param list and no return type are set' do
      before { matcher.without_params.without_return_type }

      it { is_expected.to eq('have method #a_method with sig { params().void }') }
    end
  end

  describe '#with_params' do
    it 'raises an exception if the param list is empty' do
      expect { matcher.with_params({}) }.to raise_exception('params cannot be empty')
    end
  end
end
