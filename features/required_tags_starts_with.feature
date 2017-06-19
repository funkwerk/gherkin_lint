Feature: Required Tags Starts With
  As a tester I dont want to miss certain tags on my scenarios

  Background: Prepare Testee
    Given a file named ".gherkin_lint.yml" with:
    """
    ---
    AvoidOutlineForSingleExample:
        Enabled: false
    AvoidPeriod:
        Enabled: false
    AvoidScripting:
        Enabled: false
    BackgroundDoesMoreThanSetup:
        Enabled: false
    BackgroundRequiresMultipleScenarios:
        Enabled: false
    BadScenarioName:
        Enabled: false
    BeDeclarative:
        Enabled: false
    FileNameDiffersFeatureName:
        Enabled: false
    MissingExampleName:
        Enabled: false
    MissingFeatureDescription:
        Enabled: false
    MissingFeatureName:
        Enabled: false
    MissingScenarioName:
        Enabled: false
    MissingTestAction:
        Enabled: false
    MissingVerification:
        Enabled: false
    InvalidFileName:
        Enabled: false
    InvalidStepFlow:
        Enabled: false
    RequiredTagsStartsWith:
        Enabled: true
        Matcher: ['PB','MCC']
    SameTagForAllScenarios:
        Enabled: false
    TagUsedMultipleTimes:
        Enabled: false
    TooClumsy:
        Enabled: false
    TooManyDifferentTags:
        Enabled: false
    TooManySteps:
        Enabled: false
    TooManyTags:
        Enabled: false
    TooLongStep:
        Enabled: false
    UniqueScenarioNames:
        Enabled: false
    UnknownVariable:
        Enabled: false
    UnusedVariable:
        Enabled: false
    UseBackground:
        Enabled: false
    UseOutline:
        Enabled: false
    """
    And a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
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
      No issue was found against 1 enabled linters
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
      No issue was found against 1 enabled linters
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
      No issue was found against 1 enabled linters
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
      No issue was found against 1 enabled linters
      """
