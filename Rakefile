# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

desc 'Run sorbet type checks'
task :sorbet do
  require 'English'

  exit $CHILD_STATUS&.exitstatus || 1 unless system('srb')
end

require 'rubocop/rake_task'

RuboCop::RakeTask.new

require 'yard'

YARD::Rake::YardocTask.new

task default: %i[sorbet spec rubocop yard]
