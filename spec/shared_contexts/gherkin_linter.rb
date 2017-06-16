require 'rspec'
require_relative 'file_exists'

shared_context 'a gherkin linter' do
  include_context 'a file exists'

  let(:files) { linter.analyze file }
  let(:disable_tags) { linter.disable_tags }

  before :each do
    subject.instance_variable_set(:@pattern, pattern)
    subject.lint_files({ file: files }, disable_tags)
  end
end
