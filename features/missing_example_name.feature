@disableUnknownVariable
Feature: Missing Example Name
  As a Customer
  I want examples to be named
  so that I'm able to understand why this example exists

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(MissingExampleName)
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Missing Example Name
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario Outline: A
          When test
          Then <value>

          Examples:
            | value |
            | test  |

          Examples:
            | value |
            | test  |
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      MissingExampleName - No Example Name
        lint.feature (2): Test.A
      MissingExampleName - No Example Name
        lint.feature (2): Test.A

      """

  Scenario: Names could be omitted for scenarios with a single example
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario Outline: A
          When test
          Then <value>

          Examples:
            | value |
            | test  |
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """

  Scenario: Valid Example
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario Outline: A
          When stress with <list>
          And with <character>
          Then program does not crash

          Examples: Cardinality
            | list        |
            | A           |
            | A and B     |
            | A, B, and C |

          Examples: Non Ascii Characters
            | character |
            | ä         |
            | ß         |
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """
