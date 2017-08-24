Feature: Precedence
  As a User
  I want to be able to turn linters of and on with configuration and CLI
  so that it's easier to enable and disable linters

  Scenario: Disable With local override
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """
    And a file named ".gherkin_lint.yml" with:
      """
      ---
      AvoidPeriod:
          Enabled: false
      """
    And a file named "lint.feature" with:
      """
      Feature: Lint
        A User can test a feature
        Scenario: A
          Given this is a setup
          When I run the test
          Then I see the verification.
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """

  Scenario: Disable on local, Enable on CLI
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(AvoidPeriod)
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """
    And a file named ".gherkin_lint.yml" with:
      """
      ---
      AvoidPeriod:
          Enabled: false
      """
    And a file named "lint.feature" with:
      """
      Feature: Lint
        A User can test a feature
        Scenario: A
          Given this is a setup
          When I run the test
          Then I see the verification.
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      AvoidPeriod
        lint.feature (6): Lint.A step: I see the verification.

      """
