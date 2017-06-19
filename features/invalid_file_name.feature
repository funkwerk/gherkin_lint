Feature: Invalid File Name
  As a Business Analyst
  I want to be warned about invalid file name
  so that I name all features consistently

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'
      require 'optparse'
      OptionParser.new { |opts| }.parse!

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(InvalidFileName)
      linter.set_linter
      ARGV.each { |file| linter.analyze file }
      exit linter.report

      """

  Scenario Outline: Invalid File Names
    Given a file named "<name>.feature" with:
      """
      Feature: Test
      """
    When I run `ruby lint.rb "<name>.feature"`
    Then it should fail with exactly:
      """
      InvalidFileName - Feature files should be snake_cased
        <name>.feature

      """

    Examples: Invalid Names
      | name    |
      | Lint    |
      | lintMe  |
      | lint me |
      | lint-me |

  Scenario: Valid Example
    Given a file named "lint.feature" with:
      """
      Feature: Test
      """
    When I run `ruby lint.rb lint.feature`
    Then it should pass with exactly:
      """
      """
