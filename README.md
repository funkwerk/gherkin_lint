# Lint Gherkin Files

[![Build Status](https://travis-ci.org/funkwerk/gherkin_lint.svg)](https://travis-ci.org/funkwerk/gherkin_lint)
[![Code Climate](https://codeclimate.com/github/funkwerk/gherkin_lint/badges/gpa.svg)](https://codeclimate.com/github/funkwerk/gherkin_lint)

This tool lints gherkin files.

## Usage

run `gherkin_lint` on a list of files

    gherkin_lint FEATURE_FILES

## Checks

### Feature Avoid colon (features/avoid_colon.feature)
As a Business Analyst
I do not want colons at the end of my user stories
#### Background: 
Given a file named "lint.rb" with:
"""
$LOAD_PATH << '../../lib'
require 'gherkin_lint'
linter = GherkinLint.new
linter.enable %w(AvoidColon)
linter.analyze 'lint.feature'
exit linter.report
"""
#### Scenario: Warns for colon
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
AvoidColon
  lint.feature (5): Test.A step: verification.
"""
#### Scenario: Passes for Test
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
### Feature Background does more than setup (features/background_does_more_than_setup.feature)
As a Business Analyst
I want to be warned if there is more than setup in background
so that tests stay understandable
#### Background: 
Given a file named "lint.rb" with:
"""
$LOAD_PATH << '../../lib'
require 'gherkin_lint'
linter = GherkinLint.new
linter.enable %w(BackgroundDoesMoreThanSetup)
linter.analyze 'lint.feature'
exit linter.report
"""
#### Scenario: Warns for missing verification
Given a file named "lint.feature" with:
"""
Feature: Test
  Background: Preparation
    Given setup
    When test
"""
When I run `ruby lint.rb`
Then it should fail with exactly:
"""
BackgroundDoesMoreThanSetup - Just Given Steps allowed
  lint.feature (4): Test.Preparation step: test
"""
#### Scenario: Passes for valid feature
Given a file named "lint.feature" with:
"""
Feature: Test
  Background: Preparation
    Given setup
"""
When I run `ruby lint.rb`
Then it should pass with exactly:
"""
"""
### Feature Invalid File Name (features/invalid_file_name.feature)
As a Business Analyst
I want to be warned about invalid file named
so that I name all features consistently
#### Background: 
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
#### Scenario Outline: Warns for "verification" within scenario name
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
##### Examples: Invalid Names
| invalid name |
| Lint |
| lintMe |
#### Scenario: Passes for unique scenario names
Given a file named "lint.feature" with:
"""
Feature: Test
"""
When I run `ruby lint.rb lint.feature`
Then it should pass with exactly:
"""
"""
### Feature Invalid Scenario Name (features/invalid_scenario_name.feature)
As a Business Analyst
I want to be warned about invalid scenario names
so that I am able to look for better naming
#### Background: 
Given a file named "lint.rb" with:
"""
$LOAD_PATH << '../../lib'
require 'gherkin_lint'
linter = GherkinLint.new
linter.enable %w(InvalidScenarioName)
linter.analyze 'lint.feature'
exit linter.report
"""
#### Scenario Outline: Warns for "verification" within scenario name
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
##### Examples: bad words
| bad word |
| Verifies |
| Verification |
| Verify |
| Checks |
| Check |
| Tests |
| Test |
#### Scenario: Passes for unique scenario names
Given a file named "lint.feature" with:
"""
Feature: Unique Scenario Names
  Scenario: A
"""
When I run `ruby lint.rb`
Then it should pass with exactly:
"""
"""
### Feature Invalid Step Flow (features/invalid_step_flow.feature)
As a Business Analyst
I want to be warned about invalid step flow
so that all my tests make sense
#### Background: 
Given a file named "lint.rb" with:
"""
$LOAD_PATH << '../../lib'
require 'gherkin_lint'
linter = GherkinLint.new
linter.enable %w(InvalidStepFlow)
linter.analyze 'lint.feature'
exit linter.report
"""
#### Scenario: Verification before Action
Given a file named "lint.feature" with:
"""
Feature: Test
  Scenario: A
    Given setup
    Then verify
"""
When I run `ruby lint.rb`
Then it should fail with exactly:
"""
InvalidStepFlow - Verification before action
  lint.feature (4): Test.A step: verify
"""
#### Scenario: Setup after Action
Given a file named "lint.feature" with:
"""
Feature: Test
  Scenario: A
    When test
    Given setup
    Then verify
"""
When I run `ruby lint.rb`
Then it should fail with exactly:
"""
InvalidStepFlow - Given after Action or Verification
  lint.feature (4): Test.A step: setup
"""
#### Scenario: Action as last step
Given a file named "lint.feature" with:
"""
Feature: Test
  Scenario: A
    Given setup
    When test
    Then verify
    When test
"""
When I run `ruby lint.rb`
Then it should fail with exactly:
"""
InvalidStepFlow - Last step is an action
  lint.feature (6): Test.A step: test
"""
#### Scenario: Passes for Test
Given a file named "lint.feature" with:
"""
Feature: Test
  Scenario: A
    Given setup
    When test
    Then verification
    When test
    Then verification
"""
When I run `ruby lint.rb`
Then it should pass with exactly:
"""
"""
### Feature Missing Example Name (features/missing_example_name.feature)
As a Customer
I want examples to be named
so that I'm able to understand why this example exists
#### Background: 
Given a file named "lint.rb" with:
"""
$LOAD_PATH << '../../lib'
require 'gherkin_lint'
linter = GherkinLint.new
linter.enable %w(MissingExampleName)
linter.analyze 'lint.feature'
exit linter.report
"""
#### Scenario: Warns for missing example name
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
Then it should fail with exactly:
"""
MissingExampleName - No Example Name
  lint.feature (2): Test.A
"""
#### Scenario: Passes for valid feature
Given a file named "lint.feature" with:
"""
Feature: Test
  Scenario Outline: A
    When test
    Then <value>
    Examples: Table
      | value |
      | test  |
"""
When I run `ruby lint.rb`
Then it should pass with exactly:
"""
"""
### Feature Missing Feature Description (features/missing_feature_description.feature)
As a Customer
I want feature descriptions
so that I know why the features exist
#### Background: 
Given a file named "lint.rb" with:
"""
$LOAD_PATH << '../../lib'
require 'gherkin_lint'
linter = GherkinLint.new
linter.enable %w(MissingFeatureDescription)
linter.analyze 'lint.feature'
exit linter.report
"""
#### Scenario: Warns for missing feature name
Given a file named "lint.feature" with:
"""
Feature: Test
"""
When I run `ruby lint.rb`
Then it should fail with exactly:
"""
MissingFeatureDescription - Favor a user story as description
  lint.feature (1): Test
"""
#### Scenario: Passes for valid feature
Given a file named "lint.feature" with:
"""
Feature: Test
  As a feature
  I want to have a description,
  so that everybody know why I exist
"""
When I run `ruby lint.rb`
Then it should pass with exactly:
"""
"""
### Feature Missing Feature Name (features/missing_feature_name.feature)
As a Customer
I want named features
so that I know what the feature is about just by reading the name
#### Background: 
Given a file named "lint.rb" with:
"""
$LOAD_PATH << '../../lib'
require 'gherkin_lint'
linter = GherkinLint.new
linter.enable %w(MissingFeatureName)
linter.analyze 'lint.feature'
exit linter.report
"""
#### Scenario: Warns for missing feature name
Given a file named "lint.feature" with:
"""
Feature:
"""
When I run `ruby lint.rb`
Then it should fail with exactly:
"""
MissingFeatureName - No Feature Name
  lint.feature
"""
#### Scenario: Passes for valid feature
Given a file named "lint.feature" with:
"""
Feature: Test
"""
When I run `ruby lint.rb`
Then it should pass with exactly:
"""
"""
### Feature Missing Scenario Name (features/missing_scenario_name.feature)
As a Customer
I want named scenarios
so that I know what this scenario is about without reading it
#### Background: 
Given a file named "lint.rb" with:
"""
$LOAD_PATH << '../../lib'
require 'gherkin_lint'
linter = GherkinLint.new
linter.enable %w(MissingScenarioName)
linter.analyze 'lint.feature'
exit linter.report
"""
#### Scenario: Warns for missing scenario name
Given a file named "lint.feature" with:
"""
Feature: Test
  Scenario:
"""
When I run `ruby lint.rb`
Then it should fail with exactly:
"""
MissingScenarioName - No Scenario Name
  lint.feature (2): Test
"""
#### Scenario: Warns for missing scenario outline name
Given a file named "lint.feature" with:
"""
Feature: Test
  Scenario Outline:
"""
When I run `ruby lint.rb`
Then it should fail with exactly:
"""
MissingScenarioName - No Scenario Name
  lint.feature (2): Test
"""
#### Scenario: Passes for valid feature
Given a file named "lint.feature" with:
"""
Feature: Test
  Scenario: A
"""
When I run `ruby lint.rb`
Then it should pass with exactly:
"""
"""
### Feature Missing Test Action (features/missing_test_action.feature)
As a Business Analyst
I want to be warned if I missed an action to test
so that all my scenarios actually stimulate the system and provoke a behavior
#### Background: 
Given a file named "lint.rb" with:
"""
$LOAD_PATH << '../../lib'
require 'gherkin_lint'
linter = GherkinLint.new
linter.enable %w(MissingTestAction)
linter.analyze 'lint.feature'
exit linter.report
"""
#### Scenario: Warns for missing action
Given a file named "lint.feature" with:
"""
Feature: Test
  Scenario: A
    Given setup
    Then verification
"""
When I run `ruby lint.rb`
Then it should fail with exactly:
"""
MissingTestAction - No 'When'-Step
  lint.feature (2): Test.A
"""
#### Scenario: Passes for valid feature
Given a file named "lint.feature" with:
"""
Feature: Test
  Scenario: A
    Given setup
    When action
    Then verification
"""
When I run `ruby lint.rb`
Then it should pass with exactly:
"""
"""
### Feature Missing Verification (features/missing_verification.feature)
As a Business Analyst
I want that each test contains at least one verification
so that I'm sure that the behavior of the system is tested
#### Background: 
Given a file named "lint.rb" with:
"""
$LOAD_PATH << '../../lib'
require 'gherkin_lint'
linter = GherkinLint.new
linter.enable %w(MissingVerification)
linter.analyze 'lint.feature'
exit linter.report
"""
#### Scenario: Warns for missing verification
Given a file named "lint.feature" with:
"""
Feature: Test
  Scenario: A
    Given setup
    When test
"""
When I run `ruby lint.rb`
Then it should fail with exactly:
"""
MissingVerification - No verification step
  lint.feature (2): Test.A
"""
#### Scenario: Passes for valid feature
Given a file named "lint.feature" with:
"""
Feature: Test
  Scenario: A
    Given setup
    When action
    Then verification
"""
When I run `ruby lint.rb`
Then it should pass with exactly:
"""
"""
### Feature Unique Scenario Names (features/unique_scenario_names.feature)
As a Customer
I want unique scenario names
so that I can refer to them in case of issues
#### Background: 
Given a file named "lint.rb" with:
"""
$LOAD_PATH << '../../lib'
require 'gherkin_lint'
linter = GherkinLint.new
linter.enable %w(UniqueScenarioNames)
linter.analyze 'lint.feature'
exit linter.report
"""
#### Scenario: Warns for non unique scenario name
Given a file named "lint.feature" with:
"""
Feature: Unique Scenario Names
  Scenario: A
  Scenario: A
"""
When I run `ruby lint.rb`
Then it should fail with exactly:
"""
UniqueScenarioNames - 'Unique Scenario Names.A' used 2 times
  lint.feature (2): Unique Scenario Names.A
  lint.feature (3): Unique Scenario Names.A
"""
#### Scenario: Passes for unique scenario names
Given a file named "lint.feature" with:
"""
Feature: Unique Scenario Names
  Scenario: A
  Scenario: B
"""
When I run `ruby lint.rb`
Then it should pass with exactly:
"""
"""
### Feature Unused Variable (features/unused_variable.feature)
As a Business Analyst
I want to be warned about unused variables
so that I can delete them if they are not used any more or refer them again
#### Background: 
Given a file named "lint.rb" with:
"""
$LOAD_PATH << '../../lib'
require 'gherkin_lint'
linter = GherkinLint.new
linter.enable %w(UnusedVariable)
linter.analyze 'lint.feature'
exit linter.report
"""
#### Scenario: Unused Variable in step
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


#### Scenario: Unused Variable in table

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


#### Scenario: Unused Variable in pystring

Given a file named "lint.feature" with:
"""
Feature: Test
  Scenario Outline: A
    When test
    """
      <bar>
    """
    
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


#### Scenario: Passes for Test

Given a file named "lint.feature" with:
"""
Feature: Test
  Scenario Outline: A
    Given <first>
      | value    |
      | <second> |
    When test
      """
        <third>
      """
  
    Examples: Test
      | first      | second | third |
      | used value | used   | also  |
"""
When I run `ruby lint.rb`
Then it should pass with exactly:
"""

"""

