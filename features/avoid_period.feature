Feature: Avoid Period
  As a Business Analyst
  I do not want a period at the end of the scenario
  so that it's easier to reuse verification steps

  Background: Prepare Testee
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'chutney'

      linter = Chutney::ChutneyLint.new
      linter.enable %w(AvoidPeriod)
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Steps With Period
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
          Given setup
          When test
          Then verification.
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      AvoidPeriod - Avoid using a period (full-stop) in steps so that it is easier to re-use them
        lint.feature (5): Test.A step: verification.

      """

  Scenario: Valid Example
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
          Given setup
          When test
          Then verification
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """
