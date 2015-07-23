require 'rake/testtask'

task default: :build

desc 'Builds the Gem.'
task build: :format
task build: :self_check
task build: :test do
  sh 'gem build gherkin_lint.gemspec'
end

desc 'Publishes the Gem'
task :push do
  sh 'gem push gherkin_lint-0.0.11.gem'
end

desc 'Checks ruby style'
task :rubocop do
  sh 'rubocop'
end

task test: :rubocop
task test: :language
task :test do
  sh 'cucumber --tags ~@skip'
end

task :format do
  options = []
  options.push '--replace' if ENV['repair']
  sh "gherkin_format #{options.join ' '} features/*.feature"
end

task :language do
  # TODO: sh 'gherkin_language features/*.feature'
end

task :self_check do
  sh 'RUBYLIB=lib ./bin/gherkin_lint --disable UnknownVariable,BadScenarioName features/*.feature'
end
