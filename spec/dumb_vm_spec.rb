# frozen_string_literal: true

RSpec.describe DumbVM do
  it 'has a version number' do
    expect(DumbVM::VERSION).not_to be_nil
  end

  it 'does something useful' do
    value = true

    expect(value).to be(true)
  end
end
