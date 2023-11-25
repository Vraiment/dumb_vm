# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

desc 'Run RSpec examples'
task spec: %i[spec:unit spec:integ]

namespace :spec do
  desc 'Run RSpec examples (for unit tests)'
  RSpec::Core::RakeTask.new(:unit) do |task|
    task.rspec_opts = %w[
      --format documentation
      --out tmp/rspec/unit/output.txt
      --format html
      --out tmp/rspec/unit/index.html
      --format progress
      --tag ~integ
    ]
  end

  desc 'Run RSpec examples (for integ tests)'
  RSpec::Core::RakeTask.new(:integ) do |task|
    task.rspec_opts = %w[
      --format documentation
      --out tmp/rspec/integ/output.txt
      --format html
      --out tmp/rspec/integ/index.html
      --format progress
      --tag integ
    ]
  end
end

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
