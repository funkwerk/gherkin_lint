@disableUnknownVariable
Feature: Unused Variable
  As a Business Analyst
  I want to be warned about unused variables
  so that I can delete them if they are not used anymore or refer them again

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(UnusedVariable)
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Unused Step Variable
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario Outline: A
          When <bar>

          Examples: Values
            | bar | foo |
            | 1   | 2   |
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      UnusedVariable - '<foo>' is unused
        lint.feature (2): Test.A

      """

  Scenario: Unused Table Variable
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario Outline: A
          When test
           | value |
           | <bar> |

          Examples: Values
            | bar | foo |
            | 1   | 2   |
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      UnusedVariable - '<foo>' is unused
        lint.feature (2): Test.A

      """

  Scenario: Unused Pystring Variable
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario Outline: A
          When test
          \"\"\"
            <bar>
          \"\"\"

          Examples: Values
            | bar | foo |
            | 1   | 2   |
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      UnusedVariable - '<foo>' is unused
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
