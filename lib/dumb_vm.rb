# frozen_string_literal: true
# typed: strong

require_relative 'dumb_vm/version'

# DumbVM is a gem to describe virtual machines on Ruby. This is a proof of
# concept and you shouldn't really be using this unless maybe for educational
# proposes. The preferred way to use the gem is using the DSL but the individual
# components are also available to use.
module DumbVM
  extend T::Sig

  class Error < StandardError; end

  sig { params(_name: T.any(String, Module, Symbol)).void }
  def self.describe(_name); end

  class InvalidStateException; end # rubocop:disable Lint/EmptyClass

  class Memory; end # rubocop:disable Lint/EmptyClass

  class Register; end # rubocop:disable Lint/EmptyClass
end
