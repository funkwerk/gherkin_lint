# Lint Gherkin Files

[![Build Status](https://travis-ci.org/funkwerk/gherkin_lint.svg)](https://travis-ci.org/funkwerk/gherkin_lint)
[![Code Climate](https://codeclimate.com/github/funkwerk/gherkin_lint/badges/gpa.svg)](https://codeclimate.com/github/funkwerk/gherkin_lint)

This tool lints gherkin files.

## Usage

run `gherkin_lint` on a list of files

    gherkin_lint FEATURE_FILES

With `--disable CHECK` or `--enable CHECK` it's possible to disable respectivly enable program wide checks.

Checks could be disabled using tags within Feature Files. To do so, add @disableCHECK.
Detailed usage within the [disable_tags](https://github.com/funkwerk/gherkin_lint/blob/master/features/disable_tags.feature) feature.


## Checks

| Name                             | Details                                                                                                           |
| -------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| avoid outline for single example | [Details](https://github.com/funkwerk/gherkin_lint/blob/master/features/avoid_outline_for_single_example.feature) |
| avoid period                     | [Details](https://github.com/funkwerk/gherkin_lint/blob/master/features/avoid_period.feature)                     |
| avoid scripting                  | [Details](https://github.com/funkwerk/gherkin_lint/blob/master/features/avoid_scripting.feature                   |
| background does more than setup  | [Details](https://github.com/funkwerk/gherkin_lint/blob/master/features/background_does_more_than_setup.feature)  |
| background requires scenario     | [Details](https://github.com/funkwerk/gherkin_lint/blob/master/features/background_requires_scenario.feature)     |
| bad scenario name                | [Details](https://github.com/funkwerk/gherkin_lint/blob/master/features/bad_scenario_name.feature)                |
| file name differs feature name   | [Details](https://github.com/funkwerk/gherkin_lint/blob/master/features/file_name_differs_feature_name.feature)   |
| invalid file name                | [Details](https://github.com/funkwerk/gherkin_lint/blob/master/features/invalid_file_name.feature)                |
| invalid step flow                | [Details](https://github.com/funkwerk/gherkin_lint/blob/master/features/invalid_step_flow.feature)                |
| missing example name             | [Details](https://github.com/funkwerk/gherkin_lint/blob/master/features/missing_example_name.feature)             |
| missing feature description      | [Details](https://github.com/funkwerk/gherkin_lint/blob/master/features/missing_feature_description.feature)      |
| missing feature name             | [Details](https://github.com/funkwerk/gherkin_lint/blob/master/features/missing_feature_name.feature)             |
| missing scenario name            | [Details](https://github.com/funkwerk/gherkin_lint/blob/master/features/missing_scenario_name.feature)            |
| missing test action              | [Details](https://github.com/funkwerk/gherkin_lint/blob/master/features/missing_test_action.feature)              |
| missing verification             | [Details](https://github.com/funkwerk/gherkin_lint/blob/master/features/missing_verification.feature)             |
| same tag for all scenarios       | [Details](https://github.com/funkwerk/gherkin_lint/blob/master/features/same_tag_for_all_scenarios.feature)       |
| too clumsy                       | [Details](https://github.com/funkwerk/gherkin_lint/blob/master/features/too_clumsy.feature)                       |
| too long step                    | [Details](https://github.com/funkwerk/gherkin_lint/blob/master/features/too_long_step.feature)                    |
| too many different tags          | [Details](https://github.com/funkwerk/gherkin_lint/blob/master/features/too_many_different_tags.feature)          |
| too many steps                   | [Details](https://github.com/funkwerk/gherkin_lint/blob/master/features/too_many_steps.feature)                   |
| too many tags                    | [Details](https://github.com/funkwerk/gherkin_lint/blob/master/features/too_many_tags.feature)                    |
| unique scenario names            | [Details](https://github.com/funkwerk/gherkin_lint/blob/master/features/unique_scenario_names.feature)            |
| unknown variable                 | [Details](https://github.com/funkwerk/gherkin_lint/blob/master/features/unknown_variable.feature)                 |
| use background                   | [Details](https://github.com/funkwerk/gherkin_lint/blob/master/features/use_background.feature)                   |
| use outline                      | [Details](https://github.com/funkwerk/gherkin_lint/blob/master/features/use_outline.feature)                      |
