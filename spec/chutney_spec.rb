require 'rspec'
require 'chutney'
require 'chutney/linter/tag_constraint'
require 'shared_contexts/file_exists'

describe Chutney::ChutneyLint do
  it 'should have the constant set' do
    expect(Chutney::ChutneyLint.const_defined?(:LINTER)).to be true
  end

  subject { Chutney::ChutneyLint.new }

  describe '#initialize' do
    it 'sets the files instance variable to empty' do
      expect(subject.instance_variable_get(:@files)).to eq({})
    end

    it 'sets the linter instance variable to empty' do
      expect(subject.instance_variable_get(:@linter).size).to eq(0)
    end
  end

  describe '#enable' do
    it 'enables the linter passed in' do
      subject.enable ['RequiredTagsStartsWith']
      expect(subject.instance_variable_get(:@config).config).to include('RequiredTagsStartsWith' => { 'Enabled' => true })
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
      <<-CONTENT
---
AvoidOutlineForSingleExample:
    Enabled: false
      CONTENT
    end
    it 'should load and merge the expected values from the user config file' do
      expect(subject.instance_variable_get(:@config).config).to include('AvoidOutlineForSingleExample' => { 'Enabled' => false })
    end
  end

  context 'when linter member value is passed by the user' do
    include_context 'a file exists'
    let(:file) { '.gherkin_lint.yml' }
    let(:file_content) do
      <<-CONTENT
---
RequiredTags:
    Enabled: true
    Member: Value
      CONTENT
    end

    it 'updates the member in the config' do
      expect(subject.instance_variable_get(:@config).config).to include('RequiredTags' => { 'Enabled' => true, 'Member' => 'Value' })
    end
  end
end
