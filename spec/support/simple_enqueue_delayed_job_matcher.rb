# -*- encoding : utf-8 -*-
# Public: This is a simple matcher for matching text in the handler of a delayed job,
#         this is good enough in most cases to detect if a particuluar job was queued
#
# expected_job_text - Name of method or custom job handled asyncronously
#
# Examples
#
#   expect { subscription.cancel! }.to create_delayed_job_with(:MyJob)
#
# Returns true or error message on failure
RSpec::Matchers.define(:create_delayed_job_with) do |expected_job_symbol|
  supports_block_expectations

  match do |actual_block|
    actual_block.call
    Delayed::Job.any? {|job| job.handler =~ /#{expected_job_symbol.to_s}/}
  end

  failure_message do |actual|
    "Expected the given action to create a delayed job with content: '#{expected_job_symbol.to_s}' but got: \n\n#{organize_array_output(Delayed::Job.all)}"
  end

  failure_message_when_negated do |actual|
    "Expected the given action to not create a delayed job with content: '#{expected_job_symbol.to_s}' but got: \n\n#{organize_array_output(Delayed::Job.all)}"
  end

  def organize_array_output(arr)
    arr.map {|i| i.inspect}.join("\n\n")
  end

  def supports_block_expectations?
    true
  end
end
