require 'rspec'
require 'gherkin_lint/linter/required_tags'
require 'gherkin_lint'
require 'shared_contexts/file_exists'

shared_context 'a gherkin linter' do
  include_context 'a file exists'

  let(:files) { linter.analyze file }
  let(:disable_tags) { linter.disable_tags }

  before :each do
    subject.instance_variable_set(:@pattern, /PB|MCC/)
    subject.lint_files({ file: files }, disable_tags)
  end
end

describe GherkinLint::RequiredTags do
  let(:linter) { GherkinLint::GherkinLint.new }
  let(:file) { 'lint.feature' }

  describe '#matcher' do
    it 'should raise an error when pattern is nil' do
      expect { subject.matcher(nil) }.to raise_error("No Tags provided in the YAML")
    end
    it 'should raise an error when pattern is empty' do
      expect{subject.matcher('')}.to output("Required Tags matcher has no value\n").to_stderr
    end
  end

  describe '#issues' do
    it 'should have no issue before linting' do
      expect(subject.issues.size).to eq(0)
    end
  end

  describe '#issues' do
    include_context 'a gherkin linter'

    let(:file_content) do
      <<-content
      @PB
      Feature: Test
        @scenario_tag
        Scenario: A
      content
    end
    it 'should have no issues after linting a file with a PB tag at the feature level' do
      expect(subject.issues.size).to eq(0)
    end
  end

  describe '#issues' do
    include_context 'a gherkin linter'
    let(:file_content) do
      <<-content
      @feature)tag
      Feature: Test
        @MCC
        Scenario: A
      content
    end

    it 'should have no issues after linting a file with a MCC tag at the scenario level' do
      expect(subject.issues.size).to eq(0)
    end
  end
  describe '#issues' do
    include_context 'a gherkin linter'
    let(:file_content) do
      <<-content
      @feature_tag
      Feature: Test
        @scenario_tag
        Scenario: A
      content
    end

    it 'should have issues after linting a file without PB or MCC tags' do
      expect(subject.issues[0].name).to eq(subject.class.name.split('::').last)
    end
  end
end
