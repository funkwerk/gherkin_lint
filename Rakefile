require 'rake/testtask'

task default: :build

desc 'Builds the Gem.'
task build: :format
task build: :test do
  sh 'gem build gherkin_lint.gemspec'
end

desc 'Publishes the Gem'
task :push do
  sh 'gem push gherkin_lint-0.0.1.gem'
end

desc 'Checks ruby style'
task :rubocop do
  sh 'rubocop'
end

task test: :rubocop
task :test do
  sh 'cucumber --tags ~@skip'
end

task :format do
  options = %w(--replace) if ENV['repair']
  sh "gherkin_format #{options.join ' '} features/*.feature"
end

task :language do
  sh 'gherkin_language features/*.feature'
end
