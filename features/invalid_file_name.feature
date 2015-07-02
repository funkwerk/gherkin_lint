Feature: Invalid File Name
  As a Business Analyst
  I want to be warned about invalid file named
  so that I name all features consistently

  Background:
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'
      require 'optparse'
      options = {}
      OptionParser.new { |opts| }.parse!

      linter = GherkinLint.new
      linter.enable %w(InvalidFileName)
      ARGV.each { |file| linter.analyze file }
      exit linter.report

      """

  Scenario Outline: Warns for "verification" within scenario name
    Given a file named "<invalid name>.feature" with:
      """
      Feature: Test
      """
    When I run `ruby lint.rb <invalid name>.feature`
    Then it should fail with exactly:
      """
      InvalidFileName - Feature files should be snake_cased
        <invalid name>.feature

      """
    
    Examples: Invalid Names
      | invalid name |
      | Lint         |
      | lintMe       |

  Scenario: Passes for unique scenario names
    Given a file named "lint.feature" with:
      """
      Feature: Test
      """
    When I run `ruby lint.rb lint.feature`
    Then it should pass with exactly:
      """

      """
