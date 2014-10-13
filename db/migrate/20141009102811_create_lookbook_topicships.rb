class CreateLookbookTopicships < ActiveRecord::Migration
  def change
    create_table :lookbook_topicships do |t|
      t.integer :lookbook_id
      t.integer :topic_id

      t.timestamps
    end
  end
end
