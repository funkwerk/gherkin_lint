# Disable rubocop checks for the .gemspec
# I'll take the output from 'bundle gem new' to be authoritative
# rubocop:disable all

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chutney/version'

Gem::Specification.new do |spec|
  spec.name        = 'chutney'
  spec.version     = Chutney::VERSION
  spec.authors     = ['Nigel Brookes-Thomas', 'Stefan Rohe', 'Nishtha Argawal', 'John Gluck']
  spec.email       = ['nigel@brookes-thomas.co.uk']

  spec.summary     = 'A linter for English language Gherkin'
  spec.description = 'A fork of gherkin_lint (https://github.com/funkwerk/gherkin_lint) '  \
                  'which is no-longer being actively maintained'

  spec.homepage    = 'https://github.com/BillyRuffian/chutney'
  spec.license     = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    # spec.metadata['allowed_push_host'] = 'TODO: Set to 'http://mygemserver.com''

    # spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/BillyRuffian/faker_maker'
    # spec.metadata['changelog_uri'] = 'TODO: Put your gem's CHANGELOG.md URL here.'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|s|features)/}) }
  end
  
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  
  spec.add_runtime_dependency 'amatch', '~> 0.4.0'
  spec.add_runtime_dependency 'engtagger', '~> 0.2'
  spec.add_runtime_dependency 'cucumber', '~> 3.0'
  spec.add_runtime_dependency 'multi_json', '~> 1.0'
  spec.add_runtime_dependency 'term-ansicolor', '1.7.1'
  
  spec.add_development_dependency 'aruba', '~> 0.14.0'
  spec.add_development_dependency 'rubocop', '~> 0.68.0'
  
end
