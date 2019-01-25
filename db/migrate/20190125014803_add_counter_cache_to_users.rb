class AddCounterCacheToUsers < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :article_count, :integer, default: 0, null: false
    add_column :users, :edit_count, :integer, default: 0, null: false

    say_with_time "Updating article_count for all User records" do
      ActiveRecord::Base.connection.execute <<~SQL.squish
        UPDATE users
        SET article_count = (SELECT count(1)
                                   FROM articles
                                  WHERE articles.author_id = users.id)
      SQL
    end

    say_with_time "Updating edit_count for all User records" do
      ActiveRecord::Base.connection.execute <<~SQL.squish
        UPDATE users
        SET edit_count = (SELECT count(1)
                                   FROM articles
                                  WHERE articles.editor_id = users.id)
      SQL
    end
  end

  def down
    remove_column :users, :article_count
    remove_column :users, :edit_count
  end
end
