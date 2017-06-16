Feature: Ensure Required Tags are present
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
      linter.enable %w(RequiredTagsStartsWith)
      linter.analyze 'lint.feature'
      exit linter.report

      """
    Scenario: Scenario without required tags
      Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
          When <A>
          Then <B>
      """
      When I run `ruby lint.rb`
      Then it should fail with exactly:
      """
      RequiredTagsStartsWith - Required Tag not found
        lint.feature (2): Test.A

      """

  Scenario: Scenario without required tags
    Given a file named "lint.feature" with:
      """
      @PB-1234
      Feature: Test
        Scenario: A
          When <A>
          Then <B>
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """

      """

  Scenario: Scenario without required tags
    Given a file named "lint.feature" with:
      """
      @MCC-1234
      Feature: Test
        Scenario: A
          When <A>
          Then <B>
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """

      """

  Scenario: Scenario without required tags
    Given a file named "lint.feature" with:
      """
      Feature: Test
        @PB-1234
        Scenario: A
          When <A>
          Then <B>
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """

      """

  Scenario: Scenario without required tags
    Given a file named "lint.feature" with:
      """
      Feature: Test
        @MCC-1234
        Scenario: A
          When <A>
          Then <B>
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """

      """
