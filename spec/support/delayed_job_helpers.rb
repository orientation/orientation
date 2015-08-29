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
  config.include(DelayedJobHelpers::InstanceMethods)
end
