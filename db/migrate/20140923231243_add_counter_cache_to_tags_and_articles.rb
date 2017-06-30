class AddCounterCacheToTagsAndArticles < ActiveRecord::Migration[4.2]
  def change
    change_table :articles do |t|
      t.integer :tags_count, default: 0, null: false
    end

    change_table :tags do |t|
      t.integer :articles_count, default: 0, null: false
    end
  end
end
