require 'rspec'
require_relative '../lib/gherkin_lint'
describe GherkinLint::GherkinLint do


  describe '#set_linter' do
    it '#{should do something}set' do
      expect(GherkinLint::GherkinLint.LINTER).not_to be_empty
    end
  end
end
