# -*- encoding : utf-8 -*-
module DelayedJobHelpers
  module InstanceMethods
    # Public: find a specific job from a stack of jobs
    #
    # content - Content can be a string or symbol. It's pretty much anything that
    #           can show up in the handler of a job which could identify it.
    #           Typically this is the method or job name
    #
    #
    # Returns the job
    def get_delayed_job_with_content(content)
      Delayed::Job.where(Delayed::Job.arel_table[:handler].matches("%#{content.to_s}%")).first
    end
  end
end

RSpec.configure do |config|
  config.fixture_path = Rails.root.join('spec', 'fixtures')
  config.include(DelayedJobHelpers::InstanceMethods)

  # rspec-rails 3 will no longer automatically infer an example group's spec type
  # from the file location. You can explicitly opt-in to the feature using this
  # config option.
  # To explicitly tag specs without using automatic inference, set the `:type`
  # metadata manually:
  #
  #     describe ThingsController, :type => :controller do
  #       # Equivalent to being in spec/controllers
  #     end
  config.infer_spec_type_from_file_location!
end
