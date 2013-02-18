class AddFuzzyMatchingExtension < ActiveRecord::Migration
  def up
    execute "create extension fuzzystrmatch"
    execute "create extension pg_trgm"
  end

  def down
    execute "drop extension fuzzystrmatch"
    execute "drop extension pg_trgm"
  end
end
