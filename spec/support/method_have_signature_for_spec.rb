# frozen_string_literal: true
# typed: false

require_relative 'have_signature_for'

module TestClass
  class WithoutSignature
    def a_method; end
  end

  class WithoutParamsAndWithoutReturnType
    extend T::Sig

    sig { void }
    def a_method; end
  end

  class WithParamsAndWithReturnType
    extend T::Sig

    sig { params(arg1: String, arg2: Integer).returns(Symbol) }
    def a_method(arg1, arg2); end
  end

  class WithWrongSignature
    extend T::Sig

    sig { params(arg: Object).returns(NilClass) }
    def a_method(arg); end
  end
end

# These are the tests for the `#have_signature_for` when used with an `expect(...)` statement.
# To simplify the tests they use a convention where the "correct signature" is the signature
# for the method `#a_method` defined on the classes under the `TestClass` module.

# rubocop:disable RSpec/MultipleExpectations These tests are for a matcher and hence it will have nested expectations, using :aggregate_failures won't work
RSpec.describe '#have_signature_for', type: :matcher do
  context 'when expecting sig { ... }' do
    context 'with a class that has the method with the signature' do
      let(:instance) { TestClass::WithoutParamsAndWithoutReturnType.new }

      it 'meets the expectation' do
        expect { expect(instance).to have_signature_for(:a_method) }.not_to raise_error
      end
    end

    context 'with a class that has the method without a signature' do
      let(:instance) { TestClass::WithoutSignature.new }

      it 'does not meet the expectation' do
        expected_error_message = 'expected method #a_method to have sig { ... } but none was found'

        expect { expect(instance).to have_signature_for(:a_method) }
          .to raise_error(RSpec::Expectations::ExpectationNotMetError, expected_error_message)
      end
    end
  end

  context 'when not expecting sig { ... }' do
    context 'with a class that has the method with the signature' do
      let(:instance) { TestClass::WithoutParamsAndWithoutReturnType.new }

      it 'does not meet the expectation' do
        expected_error_message = 'expected method #a_method not to have sig { ... }'

        expect { expect(instance).not_to have_signature_for(:a_method) }
          .to raise_error(RSpec::Expectations::ExpectationNotMetError, expected_error_message)
      end
    end

    context 'with a class that has the method without a signature' do
      let(:instance) { TestClass::WithoutSignature.new }

      it 'meets the expectation' do
        expect { expect(instance).not_to have_signature_for(:a_method) }
          .not_to raise_error
      end
    end
  end

  context 'when expecting sig { with_params(...)... }' do
    context 'with a class that has the method with the signature' do
      let(:instance) { TestClass::WithParamsAndWithReturnType.new }

      it 'meets the expectation with Modules' do
        expect { expect(instance).to have_signature_for(:a_method).with_params(arg1: String, arg2: Integer) }
          .not_to raise_error
      end

      it 'meets the expectation with Sorbet types' do
        expect do
          expect(instance).to have_signature_for(:a_method)
            .with_params(arg1: T::Utils.coerce(String), arg2: T::Utils.coerce(Integer))
        end.not_to raise_error
      end
    end

    context 'with a class that has the method without a signature' do
      let(:instance) { TestClass::WithoutSignature.new }

      it 'does not meet the expectation' do
        expected_error_message = 'expected method #a_method to have sig { params(arg1: String, arg2: Integer)... } ' \
                                 'but none was found'

        expect { expect(instance).to have_signature_for(:a_method).with_params(arg1: String, arg2: Integer) }
          .to raise_error(RSpec::Expectations::ExpectationNotMetError, expected_error_message)
      end
    end

    context 'with a class that does not have the method with the wrong signature' do
      let(:instance) { TestClass::WithWrongSignature.new }

      it 'does not meet the expectation' do
        expected_error_message = 'expected method #a_method to have sig { params(arg1: String, arg2: Integer)... } ' \
                                 'but sig { params(arg: Object)... } was found'

        expect { expect(instance).to have_signature_for(:a_method).with_params(arg1: String, arg2: Integer) }
          .to raise_error(RSpec::Expectations::ExpectationNotMetError, expected_error_message)
      end
    end
  end

  context 'when not expecting sig { with_params(...)... }' do
    context 'with a class that has the method with the signature' do
      let(:instance) { TestClass::WithParamsAndWithReturnType.new }

      it 'does not meet the expectation' do
        expected_error_message = 'expected method #a_method not to have ' \
                                 'sig { params(arg1: String, arg2: Integer)... }'

        expect { expect(instance).not_to have_signature_for(:a_method).with_params(arg1: String, arg2: Integer) }
          .to raise_error(RSpec::Expectations::ExpectationNotMetError, expected_error_message)
      end
    end

    context 'with a class that has the method without a signature' do
      let(:instance) { TestClass::WithoutSignature.new }

      it 'meets the expectation' do
        expect { expect(instance).not_to have_signature_for(:a_method).with_params(arg1: String, arg2: Integer) }
          .not_to raise_error
      end
    end

    context 'with a class that does not have the method with the wrong signature' do
      let(:instance) { TestClass::WithWrongSignature.new }

      it 'meets the expectation' do
        expect { expect(instance).not_to have_signature_for(:a_method).with_params(arg1: String, arg2: Integer) }
          .not_to raise_error
      end
    end
  end

  context 'when expecting sig { without_params... }' do
    context 'with a class that has the method with the signature' do
      let(:instance) { TestClass::WithoutParamsAndWithoutReturnType.new }

      it 'meets the expectation' do
        expect { expect(instance).to have_signature_for(:a_method).without_params }
          .not_to raise_error
      end
    end

    context 'with a class that has the method without a signature' do
      let(:instance) { TestClass::WithoutSignature.new }

      it 'does not meet the expectation' do
        expected_error_message = 'expected method #a_method to have sig { params()... } ' \
                                 'but none was found'

        expect { expect(instance).to have_signature_for(:a_method).without_params }
          .to raise_error(RSpec::Expectations::ExpectationNotMetError, expected_error_message)
      end
    end

    context 'with a class that does not have the method with the wrong signature' do
      let(:instance) { TestClass::WithWrongSignature.new }

      it 'does not meet the expectation' do
        expected_error_message = 'expected method #a_method to have sig { params()... } ' \
                                 'but sig { params(arg: Object)... } was found'

        expect { expect(instance).to have_signature_for(:a_method).without_params }
          .to raise_error(RSpec::Expectations::ExpectationNotMetError, expected_error_message)
      end
    end
  end

  context 'when not expecting sig { without_params... }' do
    context 'with a class that has the method with the signature' do
      let(:instance) { TestClass::WithoutParamsAndWithoutReturnType.new }

      it 'does not meet the expectation' do
        expected_error_message = 'expected method #a_method not to have sig { params()... }'

        expect { expect(instance).not_to have_signature_for(:a_method).without_params }
          .to raise_error(RSpec::Expectations::ExpectationNotMetError, expected_error_message)
      end
    end

    context 'with a class that has the method without a signature' do
      let(:instance) { TestClass::WithoutSignature.new }

      it 'meets meet the expectation' do
        expect { expect(instance).not_to have_signature_for(:a_method).without_params }
          .not_to raise_error
      end
    end

    context 'with a class that does not have the method with the wrong signature' do
      let(:instance) { TestClass::WithWrongSignature.new }

      it 'meets the expectation' do
        expect { expect(instance).not_to have_signature_for(:a_method).without_params }
          .not_to raise_error
      end
    end
  end

  context 'when expecting sig { ...returns(...) }' do
    context 'with a class that has the method with the signature' do
      let(:instance) { TestClass::WithParamsAndWithReturnType.new }

      it 'meets the expectation with a Module' do
        expect { expect(instance).to have_signature_for(:a_method).with_return_type(Symbol) }
          .not_to raise_error
      end

      it 'meets the expectation with a Sorbet type' do
        expect { expect(instance).to have_signature_for(:a_method).with_return_type(T::Utils.coerce(Symbol)) }
          .not_to raise_error
      end
    end

    context 'with a class that has the method without a signature' do
      let(:instance) { TestClass::WithoutSignature.new }

      it 'does not meet the expectation' do
        expected_error_message = 'expected method #a_method to have sig { ...returns(Symbol) } ' \
                                 'but none was found'

        expect { expect(instance).to have_signature_for(:a_method).with_return_type(Symbol) }
          .to raise_error(RSpec::Expectations::ExpectationNotMetError, expected_error_message)
      end
    end

    context 'with a class that does not have the method with the wrong signature' do
      let(:instance) { TestClass::WithWrongSignature.new }

      it 'does not meet the expectation' do
        expected_error_message = 'expected method #a_method to have sig { ...returns(Symbol) } ' \
                                 'but sig { ...returns(NilClass) } was found'

        expect { expect(instance).to have_signature_for(:a_method).with_return_type(Symbol) }
          .to raise_error(RSpec::Expectations::ExpectationNotMetError, expected_error_message)
      end
    end
  end

  context 'when not expecting sig { ...returns(...) }' do
    context 'with a class that has the method with the signature' do
      let(:instance) { TestClass::WithParamsAndWithReturnType.new }
      let(:expected_error_message) { 'expected method #a_method not to have sig { ...returns(Symbol) }' }

      it 'does not meet the expectation with a Module' do
        expect { expect(instance).not_to have_signature_for(:a_method).with_return_type(Symbol) }
          .to raise_error(RSpec::Expectations::ExpectationNotMetError, expected_error_message)
      end

      it 'does not meet the expectation with a Sorbet type' do
        expect { expect(instance).not_to have_signature_for(:a_method).with_return_type(T::Utils.coerce(Symbol)) }
          .to raise_error(RSpec::Expectations::ExpectationNotMetError, expected_error_message)
      end
    end

    context 'with a class that has the method without a signature' do
      let(:instance) { TestClass::WithoutSignature.new }

      it 'meets the expectation' do
        expect { expect(instance).not_to have_signature_for(:a_method).with_return_type(Symbol) }
          .not_to raise_error
      end
    end

    context 'with a class that does not have the method with the wrong signature' do
      let(:instance) { TestClass::WithWrongSignature.new }

      it 'meets the expectation' do
        expect { expect(instance).not_to have_signature_for(:a_method).with_return_type(String) }
          .not_to raise_error
      end
    end
  end

  context 'when expecting sig { ...void }' do
    context 'with a class that has the method with the signature' do
      let(:instance) { TestClass::WithoutParamsAndWithoutReturnType.new }

      it 'meets the expectation' do
        expect { expect(instance).to have_signature_for(:a_method).without_return_type }
          .not_to raise_error
      end
    end

    context 'with a class that has the method without a signature' do
      let(:instance) { TestClass::WithoutSignature.new }

      it 'does not meet the expectation' do
        expected_error_message = 'expected method #a_method to have sig { ...void } ' \
                                 'but none was found'

        expect { expect(instance).to have_signature_for(:a_method).without_return_type }
          .to raise_error(RSpec::Expectations::ExpectationNotMetError, expected_error_message)
      end
    end

    context 'with a class that does not have the method with the wrong signature' do
      let(:instance) { TestClass::WithWrongSignature.new }

      it 'does not meet the expectation' do
        expected_error_message = 'expected method #a_method to have sig { ...void } ' \
                                 'but sig { ...returns(NilClass) } was found'

        expect { expect(instance).to have_signature_for(:a_method).without_return_type }
          .to raise_error(RSpec::Expectations::ExpectationNotMetError, expected_error_message)
      end
    end
  end

  context 'when not expecting sig { ...void }' do
    context 'with a class that has the method with the signature' do
      let(:instance) { TestClass::WithoutParamsAndWithoutReturnType.new }

      it 'does not meet the expectation' do
        expected_error_message = 'expected method #a_method not to have sig { ...void }'

        expect { expect(instance).not_to have_signature_for(:a_method).without_return_type }
          .to raise_error(RSpec::Expectations::ExpectationNotMetError, expected_error_message)
      end
    end

    context 'with a class that has the method without a signature' do
      let(:instance) { TestClass::WithoutSignature.new }

      it 'meets the expectation' do
        expect { expect(instance).not_to have_signature_for(:a_method).without_return_type }
          .not_to raise_error
      end
    end

    context 'with a class that does not have the method with the wrong signature' do
      let(:instance) { TestClass::WithWrongSignature.new }

      it 'meets the expectation' do
        expect { expect(instance).not_to have_signature_for(:a_method).without_return_type }
          .not_to raise_error
      end
    end
  end

  context 'when expecting sig { params(...).returns(...) }' do
    context 'with a class that has the method with the signature' do
      let(:instance) { TestClass::WithParamsAndWithReturnType.new }

      it 'meets the expectation' do
        expect do
          expect(instance).to have_signature_for(:a_method)
            .with_params(arg1: String, arg2: Integer)
            .with_return_type(Symbol)
        end.not_to raise_error
      end
    end

    context 'with a class that has the method without a signature' do
      let(:instance) { TestClass::WithoutSignature.new }

      # rubocop:disable RSpec/ExampleLength
      it 'does not meet the expectation' do
        expected_error_message = 'expected method #a_method to have ' \
                                 'sig { params(arg1: String, arg2: Integer).returns(Symbol) } ' \
                                 'but none was found'

        expect do
          expect(instance).to have_signature_for(:a_method)
            .with_params(arg1: String, arg2: Integer)
            .with_return_type(Symbol)
        end.to raise_error(RSpec::Expectations::ExpectationNotMetError, expected_error_message)
      end
      # rubocop:enable RSpec/ExampleLength
    end

    context 'with a class that does not have the method with the wrong signature' do
      let(:instance) { TestClass::WithWrongSignature.new }

      # rubocop:disable RSpec/ExampleLength
      it 'does not meet the expectation' do
        expected_error_message = 'expected method #a_method to have ' \
                                 'sig { params(arg1: String, arg2: Integer).returns(Symbol) } ' \
                                 'but sig { params(arg: Object).returns(NilClass) } was found'

        expect do
          expect(instance).to have_signature_for(:a_method)
            .with_params(arg1: String, arg2: Integer)
            .with_return_type(Symbol)
        end.to raise_error(RSpec::Expectations::ExpectationNotMetError, expected_error_message)
      end
      # rubocop:enable RSpec/ExampleLength
    end
  end

  context 'when not expecting sig { params(...).returns(...) }' do
    context 'with a class that has the method with the signature' do
      let(:instance) { TestClass::WithParamsAndWithReturnType.new }

      # rubocop:disable RSpec/ExampleLength
      it 'does not meet the expectation' do
        expected_error_message = 'expected method #a_method not to have ' \
                                 'sig { params(arg1: String, arg2: Integer).returns(Symbol) }'

        expect do
          expect(instance).not_to have_signature_for(:a_method)
            .with_params(arg1: String, arg2: Integer)
            .with_return_type(Symbol)
        end.to raise_error(RSpec::Expectations::ExpectationNotMetError, expected_error_message)
      end
      # rubocop:enable RSpec/ExampleLength
    end

    context 'with a class that has the method without a signature' do
      let(:instance) { TestClass::WithoutSignature.new }

      it 'meets the expectation' do
        expect do
          expect(instance).not_to have_signature_for(:a_method)
            .with_params(arg1: String, arg2: Integer)
            .with_return_type(Symbol)
        end.not_to raise_error
      end
    end

    context 'with a class that does not have the method with the wrong signature' do
      let(:instance) { TestClass::WithWrongSignature.new }

      it 'meets the expectation' do
        expect do
          expect(instance).not_to have_signature_for(:a_method)
            .with_params(arg1: String, arg2: Integer)
            .with_return_type(Symbol)
        end.not_to raise_error
      end
    end
  end
end
# rubocop:enable RSpec/MultipleExpectations
