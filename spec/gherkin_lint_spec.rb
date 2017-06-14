require 'rspec'
require 'gherkin_lint'
require 'gherkin_lint/linter/required_tags'

describe GherkinLint::GherkinLint do

  it 'should have the constant set' do
    expect(GherkinLint::GherkinLint.const_defined? :LINTER).to be true
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
      subject.enable( [('RequiredTags')])
      expect(subject.instance_variable_get(:@linter).size).to eq(1)
    end
  end

end
