Feature: Invalid Scenario Name
  As a Business Analyst
  I want to be warned about invalid scenario names
  so that I am able to look for better naming

  Background:
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint.new
      linter.enable %w(InvalidScenarioName)
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario Outline: Warns for "verification" within scenario name
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: <bad word> something
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      InvalidScenarioName - Prefer to rely just on Given and When steps when name your scenario to keep it stable
        lint.feature (2): Test.<bad word> something

      """
    
    Examples: bad words
      | bad word |
      | Verifies |
      | Verification |
      | Verify |
      | Checks |
      | Check |
      | Tests |
      | Test |

  Scenario: Passes for unique scenario names
    Given a file named "lint.feature" with:
      """
      Feature: Unique Scenario Names
        Scenario: A
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """

      """
