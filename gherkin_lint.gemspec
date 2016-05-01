Gem::Specification.new do |s|
  s.name        = 'gherkin_lint'
  s.version     = '0.3.1'
  s.date        = '2016-05-01'
  s.summary     = 'Gherkin Lint'
  s.description = 'Lint Gherkin Files'
  s.authors     = ['Stefan Rohe']
  s.homepage    = 'http://github.com/funkwerk/gherkin_lint/'
  s.files       = `git ls-files`.split("\n")
  s.executables = s.files.grep(%r{^bin/}) { |file| File.basename(file) }
  s.add_runtime_dependency 'gherkin', ['= 2.12.2']
  s.add_runtime_dependency 'term-ansicolor', ['>= 1.3.2']
  s.add_runtime_dependency 'amatch', ['>= 0.3.0']
  s.add_runtime_dependency 'engtagger', ['>=0.2.0']
  s.add_development_dependency 'aruba', ['>= 0.6.2']
end
