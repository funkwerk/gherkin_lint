Then(/^it should fail with exactly:$/) do |expected|
  # Standardize line endings
  expected = expected.gsub("\n", "\r\n")

  expect(last_command_stopped).not_to be_successfully_executed
  expect(last_command_stopped).to have_output an_output_string_being_eq(expected)
end

Then(/^it should pass with exactly:$/) do |expected|
  # Standardize line endings
  expected = expected.gsub("\n", "\r\n")

  expect(last_command_stopped).to be_successfully_executed
  expect(last_command_stopped).to have_output an_output_string_being_eq(expected)
end
