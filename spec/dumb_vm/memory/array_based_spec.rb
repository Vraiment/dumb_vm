# frozen_string_literal: true

RSpec.describe DumbVM::Memory::ArrayBased do
  subject(:memory) { described_class.new(contents) }

  let(:contents) { [] }

  it { is_expected.to be_a(DumbVM::Memory) }
end
