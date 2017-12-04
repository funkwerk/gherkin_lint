Gem::Specification.new do |s|
  s.name        = 'gherkin_lint'
  s.version     = '1.2.2'
  s.date        = '2017-12-04'
  s.summary     = 'Gherkin Lint'
  s.description = 'Lint Gherkin Files'
  s.authors     = ['Stefan Rohe', 'Nishtha Argawal', 'John Gluck']
  s.homepage    = 'http://github.com/funkwerk/gherkin_lint/'
  s.license     = 'MIT'
  s.files       = `git ls-files`.split("\n")
  s.executables = s.files.grep(%r{^bin/}) { |file| File.basename(file) }
  s.add_runtime_dependency 'amatch', ['~> 0.3', '>= 0.3.0']
  s.add_runtime_dependency 'engtagger', ['~> 0.2', '>= 0.2.0']
  s.add_runtime_dependency 'gherkin', ['>= 4.0.0', '< 6.0']
  s.add_runtime_dependency 'multi_json', ['~> 1.12', '>= 1.12.1']
  s.add_runtime_dependency 'term-ansicolor', ['~> 1.3', '>= 1.3.2']
  s.add_development_dependency 'aruba', ['~> 0.6', '>= 0.6.2']
end
