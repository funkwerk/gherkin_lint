require 'rspec'
require 'gherkin_lint/configuration'
require 'shared_contexts/file_exists'

describe GherkinLint::Configuration do
  subject { GherkinLint::Configuration.new file }
  let(:file) { 'default.yml' }

  it 'should do something' do
    expect(subject.config).to eq('')
  end

  it 'should have a default config path' do
    expect(subject.configuration_path).not_to be nil
  end
  context 'when a empty config file is present' do
    include_context 'a file exists'
    let(:file_content) { '---' }
    it 'should load a file from the config path' do
      expect(subject.config).to eq ''
    end
  end

  context 'when a non-YAML config file is present' do
    include_context 'a file exists'
    let(:file_content) do
      <<-content
      foo: [
        ‘bar’, {
          baz: 42
         }
      ]'
      content
    end

    it 'should load a file from the config path but fail to parse' do
      expect { subject.load_configuration }.to raise_error
      expect { subject.config }.to raise_error
    end
  end
  context 'when a valid YAML file is present' do
    include_context 'a file exists'
    let(:file_content) do
      <<-content
---
:parent_key: parent_value
:child_key: child_value
      content
    end
    before :each do
      subject.load_configuration
    end

    it 'should load the values from the config file' do
      expect(subject.config).to eq(parent_key: 'parent_value', child_key: 'child_value')
    end
  end
end
