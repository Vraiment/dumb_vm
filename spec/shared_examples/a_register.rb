# frozen_string_literal: true

RSpec.shared_examples 'a register' do |size:|
  it { is_expected.to be_a(DumbVM::Register) }
  it { is_expected.to have_attributes(size: DumbVM::BitLength.bits(size)) }
end
