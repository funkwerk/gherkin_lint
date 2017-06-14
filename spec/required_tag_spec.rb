require 'rspec'
require 'gherkin_lint/linter/required_tags'
require 'gherkin_lint'

shared_context 'a gherkin linter' do
  before :each do
    File.open(file, 'w') do |f|
      f.write file_content
    end
  end

  after :each do
    File.delete(file) if File.exist?(file)
  end

  let(:files) { linter.analyze file }
  let(:disable_tags) { linter.disable_tags }

  before :each do
    subject.lint_files({ file: files }, disable_tags)
  end
end

describe GherkinLint::RequiredTags do
  let(:linter) { GherkinLint::GherkinLint.new }
  let(:file) { 'lint.feature' }

  describe '#issues' do
    it 'should have no issue before linting' do
      expect(subject.issues.size).to eq(0)
    end
  end

  describe '#issues' do
    include_context 'a gherkin linter'

    let(:file_content) {
      <<-content
      @PB
      Feature: Test
        @scenario_tag
        Scenario: A
      content
    }
    it 'should have no issues after linting a file with a PB tag at the feature level' do
      expect(subject.issues.size).to eq(0)
    end
  end

  describe '#issues' do
    include_context 'a gherkin linter'
    let(:file_content) {
      <<-content
      @feature)tag
      Feature: Test
        @MCC
        Scenario: A
      content
    }

    it 'should have no issues after linting a file with a MCC tag at the scenario level' do
      expect(subject.issues.size).to eq(0)
    end
  end
  describe '#issues' do
    include_context 'a gherkin linter'
    let(:file_content) {
      <<-content
      @feature_tag
      Feature: Test
        @scenario_tag
        Scenario: A
      content
    }

    it 'should have issues after linting a file without PB or MCC tags' do
      expect(subject.issues[0].name).to eq(subject.class.name.split('::').last)
    end
  end
end
