Gem::Specification.new do |s|
  s.name        = 'gherkin_lint'
  s.version     = '0.0.2'
  s.date        = '2015-07-04'
  s.summary     = 'Gherkin Lint'
  s.description = 'Lint Gherkin Files'
  s.authors     = ['Stefan Rohe']
  s.homepage    = 'http://github.com/funkwerk/gherkin_lint/'
  # s.files       = `git ls-files`.split("\n")
  s.files       = %w(bin/gherkin_lint lib/gherkin_lint.rb)
  s.executables = s.files.grep(%r{^bin/}) { |file| File.basename(file) }
  s.add_runtime_dependency 'gherkin', ['>= 2.12.2']
  s.add_runtime_dependency 'term-ansicolor', ['>= 1.3.2']
  s.add_development_dependency 'aruba', ['>= 0.6.2']
end
