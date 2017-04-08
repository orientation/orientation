module LogQuerySource
  def debug(*args, &block)
    return unless super

    backtrace = Rails.backtrace_cleaner.clean caller
    relevant_caller_line = backtrace.first

    if relevant_caller_line
      logger.debug("  ↳ #{ relevant_caller_line.sub("#{ Rails.root }/", '') }")
    end
  end
end

if Rails.env.development? || Rails.env.test?
  ActiveRecord::LogSubscriber.send(:prepend, LogQuerySource)
end
