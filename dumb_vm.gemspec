# frozen_string_literal: true

require_relative 'lib/dumb_vm/version'

Gem::Specification.new do |spec|
  spec.name = 'dumb_vm'
  spec.version = DumbVm::VERSION
  spec.authors = ['Vraiment']
  spec.email = ['jemc44@gmail.com']

  spec.summary = 'A dumb VM implementation.'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.1.0'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata['rubygems_mfa_required'] = 'true'
end
