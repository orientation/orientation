class ActiveRecord::Railtie
  console do
    ActiveRecord::Base.verbose_query_logs = true
  end
end
