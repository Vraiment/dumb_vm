# frozen_string_literal: true
# typed: strong

require_relative 'dumb_vm/bit_length'
require_relative 'dumb_vm/dsl'
require_relative 'dumb_vm/memory'
require_relative 'dumb_vm/memory/array_based'
require_relative 'dumb_vm/register'
require_relative 'dumb_vm/version'

# DumbVM is a gem to describe virtual machines on Ruby. This is a proof of
# concept and you shouldn't really be using this unless maybe for educational
# proposes. The preferred way to use the gem is using the DSL but the individual
# components are also available to use.
module DumbVM
  class Error < StandardError; end

  class InvalidStateException; end # rubocop:disable Lint/EmptyClass
end
