RSpec::Matchers.define(:enqueue_delayed_job) do |object, method, *args|
  supports_block_expectations

  match do |block|
    args = nil if args.empty?
    @job_count_before = Delayed::Job.count
    block.call
    jobs = Delayed::Job.all
    @matching_jobs = matching_jobs_from(jobs, object, method, args)
    @job_count_after = jobs.size

    any_jobs_enqueued? && correct_matching_job_count?
  end

  failure_message_for_should do |actual|
    if !any_jobs_enqueued?
      "#{message} should have created new a Delayed::Job, but didn't"
    elsif @matching_jobs.size == 0 && jobs = matching_jobs_from(Delayed::Job.all, object, method, nil) and jobs.present?
      "#{message} should have enqueued #{to_s}, but didn't. The following non-matching, but similar jobs (called with non-matching arguments) were enqueued: #{jobs.collect { |j| j.payload_object.inspect }.to_sentence}"
    elsif @matching_jobs.size == 0 && jobs = matching_jobs_from(Delayed::Job.all, object, nil, nil) and jobs.present?
      "#{message} should have enqueued #{to_s}, but didn't. The following non-matching, but similar jobs (calling non-matching methods) were enqueued: #{jobs.collect { |j| j.payload_object.inspect }.to_sentence}"
    elsif @matching_jobs.size == 0
      "#{message} failed to enqueue any #{to_s} jobs, or any other jobs for #{object_name}"
    else
      "#{message} failed to enqueue #{@count} jobs for #{to_s}"
    end
  end

  failure_message_for_should_not do |actual|
  end

  description do
    "delay calling #{to_s}"
  end

  chain :times do |count|
    @count = count
  end

  define_method :message do
    "result"
  end

  define_method :object_class do |o|
    o.is_a?(Class) ? o : o.class
  end

  define_method :object_name do
    if object.kind_of?(Class)
      object.name
    else
      "#<%s>" % [object.class.name]
    end
  end

  define_method :to_s do
    if object.kind_of?(Class)
      "%s.%s(%s)" % [object_name, method, args.collect(&:to_s).join(', ')]
    else
      "%s#%s(%s)" % [object_name, method, args.collect(&:to_s).join(', ')]
    end
  end

  define_method :matching_jobs_from do |jobs, object, method, args|
    local_jobs = jobs.select { |job| job.payload_object.kind_of?(::Delayed::PerformableMethod) }
    local_jobs.select! { |job| object_class(job.payload_object.object) == object_class(object) } if object
    local_jobs.select! { |job| job.payload_object.method_name.to_s =~ /^#{Regexp.escape method.to_s}(?:_without_delay)?$/ } if method
    local_jobs.select! { |job| job.payload_object.args == args } if args
    local_jobs
  end

  define_method :any_jobs_enqueued? do
    @job_count_before < @job_count_after
  end

  define_method :correct_matching_job_count? do
    (@count.nil? && @matching_jobs.size == 1) ||
      (@count == @matching_jobs.size)
  end
end
