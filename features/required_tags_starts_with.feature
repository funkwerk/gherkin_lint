Feature: Required Tags Starts With
  As a tester I dont want to miss certain tags on my scenarios

  Background: Prepare Testee
    Given a file named ".gherkin_lint.yml" with:
      """
      ---
      RequiredTagsStartsWith:
          Enabled: true
          Matcher: ['PB','MCC']
      """
    And a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.disable_all
      linter.enable %w(RequiredTagsStartsWith)
      linter.set_linter
      linter.analyze 'lint.feature'
      exit linter.report

      """
    Scenario: Scenario without required tags
      Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
          When action
          Then verification
      """
      When I run `ruby lint.rb`
      Then it should fail with exactly:
      """
      RequiredTagsStartsWith - Required Tag not found
        lint.feature (2): Test.A

      """

  Scenario: Scenario with PB Feature Tag
    Given a file named "lint.feature" with:
      """
      @PB-1234
      Feature: Test
        Scenario: A
          When action
          Then verification
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """

  Scenario: Scenario with MCC feature tag
    Given a file named "lint.feature" with:
      """
      @MCC-1234
      Feature: Test
        Scenario: A
          When action
          Then verification
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """

  Scenario: Scenario with PR Scenario tag
    Given a file named "lint.feature" with:
      """
      Feature: Test
        @PB-1234
        Scenario: A
          When action
          Then verification
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """

  Scenario: Scenario with MCC tags
    Given a file named "lint.feature" with:
      """
      Feature: Test
        @MCC-1234
        Scenario: A
          When action
          Then verification
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """
      """
