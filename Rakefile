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
  sh 'gem push gherkin_lint-1.2.2.gem'
end

desc 'Checks ruby style'
task :rubocop do
  begin
    sh 'rubocop'
  rescue RuntimeError => e
    # Rubocop failing due to style violations is fine. Other errors should bubble up to our attention.
    raise e unless e.message =~ /status \(1\).*rubocop/

    puts 'Rubocop failed'
  end
end

task test: :rubocop
task test: :language
task :test do
  sh 'cucumber --tags "not @skip" --guess'
end

task :format do
  options = []
  options.push '--replace' if ENV['repair']
  # TODO: sh "gherkin_format #{options.join ' '} features/*.feature"
end

task :language do
  # TODO: sh 'gherkin_language features/*.feature'
end

task :self_check do
  disabled_checks = %w[
    UnknownVariable
    BadScenarioName
  ]
  sh "ruby ./bin/gherkin_lint --disable #{disabled_checks.join ','} features/*.feature"
end
