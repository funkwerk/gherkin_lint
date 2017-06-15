require 'rspec'
require 'gherkin_lint'
require 'gherkin_lint/linter/required_tags'
require 'shared_contexts/file_exists'

describe GherkinLint::GherkinLint do
  it 'should have the constant set' do
    expect(GherkinLint::GherkinLint.const_defined?(:LINTER)).to be true
  end

  subject { GherkinLint::GherkinLint.new }

  describe '#initialize' do
    it 'sets the files instance variable to empty' do
      expect(subject.instance_variable_get(:@files)).to eq({})
    end

    it 'sets the linter instance variable to empty' do
      expect(subject.instance_variable_get(:@linter).size).to eq(0)
    end
  end

  describe '#enable_all' do
    it 'enables all the linters in the LINTER constant' do
      subject.enable_all
      expect(subject.instance_variable_get(:@linter).size).to eq(GherkinLint::GherkinLint::LINTER.size)
    end
  end

  describe '#enable' do
    it 'enables the linter passed in' do
      subject.enable ['RequiredTags']
      expect(subject.instance_variable_get(:@linter).size).to eq(1)
    end
  end
  context 'when user configuration is not present' do
    let(:file) { 'config/default.yml' }
    it 'should load the expected values from the config file' do
      expect(subject.instance_variable_get(:@config).config).to include('AvoidOutlineForSingleExample' => { 'Enabled' => true })
    end
  end

  context 'when user provided YAML is present' do
    include_context 'a file exists'
    let(:file) { '.gherkin_lint.yml' }
    let(:file_content) do
      <<-content
---
AvoidOutlineForSingleExample:
    Enabled: false
      content
    end
    it 'should load and merge the expected values from the user config file' do
      expect(subject.instance_variable_get(:@config).config).to include('AvoidOutlineForSingleExample' => { 'Enabled' => false })
    end
  end

  context 'when linter member value is passed by the user' do
    include_context 'a file exists'
    let(:file) { '.gherkin_lint.yml' }
    let(:file_content) do
      <<-content
---
RequiredTags:
    Enabled: true
    Member: Value
      content
    end

    it 'updates the member in the config' do
      expect(subject.instance_variable_get(:@config).config).to include('RequiredTags' => { 'Enabled' => true, 'Member' => 'Value' })
    end
  end
end
