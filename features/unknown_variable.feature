@disableUnknownVariable
Feature: Unknown Variable
  As a Business Analyst
  I want to be warned about unknown variables
  so that I can delete them if they are not defined anymore

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(UnknownVariable)
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Unknown Step Variable
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario Outline: A
          When <baz> and <bar>

          Examples: Values
            | bar |
            | 1   |
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      UnknownVariable - '<baz>' is unknown
        lint.feature (2): Test.A

      """

  Scenario: Unknown Step Variable Even For Missing Examples
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario Outline: A
          When <baz> and <bar>
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      UnknownVariable - '<baz>' is unknown
        lint.feature (2): Test.A
      UnknownVariable - '<bar>' is unknown
        lint.feature (2): Test.A

      """

  Scenario: Unknown Table Variable
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario Outline: A
          When test
           | value |
           | <baz> |

          Examples: Values
            | bar |
            | 1   |
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      UnknownVariable - '<baz>' is unknown
        lint.feature (2): Test.A

      """

  Scenario: Unknown Pystring Variable
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario Outline: A
          When test
          \"\"\"
            <baz>
          \"\"\"

          Examples: Values
            | bar |
            | 1   |
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      UnknownVariable - '<baz>' is unknown
        lint.feature (2): Test.A

      """

  Scenario: Valid Example
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario Outline: A
          Given <first>
            | value    |
            | <second> |
          When test
            \"\"\"
              <third>
            \"\"\"

          Examples: Test
            | first      | second | third |
            | used value | used   | also  |
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """
