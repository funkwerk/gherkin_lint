require 'rspec'
require 'chutney/linter/required_tags_starts_with'
require 'chutney'
require 'shared_contexts/gherkin_linter'

describe Chutney::RequiredTagsStartsWith do
  let(:linter) { Chutney::ChutneyLint.new }
  let(:file) { 'lint.feature' }
  let(:pattern) { %w[MCC PB] }
  describe '#matcher' do
    it 'should raise an error when pattern is nil' do
      expect { subject.matcher(nil) }.to raise_error('No Tags provided in the YAML')
    end
    it 'should raise an error when pattern is empty' do
      expect { subject.matcher('') }.to output("Required Tags matcher has no value\n").to_stderr
    end
  end

  describe '#issues' do
    context 'before linting' do
      it 'should have no issue' do
        expect(subject.issues.size).to eq(0)
      end
    end

    context 'after linting a feature file with valid PB tag at the feature level' do
      include_context 'a gherkin linter'

      let(:file_content) do
        <<-CONTENT
      @PB
      Feature: Test
        @scenario_tag
        Scenario: A
        CONTENT
      end
      it 'should have no issues' do
        expect(subject.issues.size).to eq(0)
      end
    end

    context 'after linting a file with a MCC tag at the scenario level' do
      include_context 'a gherkin linter'
      let(:file_content) do
        <<-CONTENT
      @feature_tag
      Feature: Test
        @MCC
        Scenario: A
        CONTENT
      end

      it 'should have no issues' do
        expect(subject.issues.size).to eq(0)
      end
    end

    context 'after linting a file with no required tags' do
      include_context 'a gherkin linter'
      let(:file_content) do
        <<-CONTENT
      @feature_tag
      Feature: Test
        @scenario_tag
        Scenario: A
        CONTENT
      end

      it 'should have issues after linting a file without PB or MCC tags' do
        expect(subject.issues[0].name).to eq(subject.class.name.split('::').last)
      end
    end
  end
end
