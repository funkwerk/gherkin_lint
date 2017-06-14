require 'rspec'
require 'gherkin_lint/configuration'

describe GherkinLint::Configuration do
  let(:file) { 'default.yml' }
  shared_context 'a configuration file' do
    before :each do
      File.open(file, 'w') do |f|
        f.write file_content
      end
    end

    after :each do
      File.delete(file) if File.exist?(file)
    end
  end

  subject { GherkinLint::Configuration.new }
  it 'should do something' do
    expect(subject.config).to eq('')
  end

  it 'should have a default config path' do
    expect(subject.configuration_path).not_to be nil
  end
  context 'when a empty config file is present' do
    include_context 'a configuration file'
    let(:file_content) { '---' }
    it 'should load a file from the config path' do
      expect(subject.config).to eq ''
    end
  end

  context 'when a non-YAML config file is present' do
    include_context 'a configuration file'
    let(:file_content) {
      <<-content
      foo: [
        ‘bar’, {
          baz: 42
         }
      ]'
      content
    }

    it 'should load a file from the config path but fail to parse' do
      expect { subject.load_configuration }.to raise_error
      expect { subject.config }.to raise_error
    end
  end
  context 'when a valid YAML file is present' do
    include_context 'a configuration file'
    let(:file_content) {
      <<-content
      ---
      :parent_key: parent_value
      :child_key: child_value
      content
    }
    before :each do
      subject.load_configuration
    end

    it 'should load the values from the config file' do
      expect(subject.config).to eq(parent_key: 'parent_value', child_key: 'child_value')
    end
  end
  context 'when a valid YAML file is present' do
    include_context 'a configuration file'
    let(:file_content) {
      <<-content
      ---
      :parent_key: parent_value
      :child_key: child_value
      content
    }
    before :each do
      subject.load_configuration
    end

    it 'should load read values from the config file' do
      expect(subject.config).to eq(parent_key: 'parent_value', child_key: 'child_value')
    end
  end
end
