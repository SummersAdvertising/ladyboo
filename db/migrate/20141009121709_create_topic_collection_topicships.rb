class CreateTopicCollectionTopicships < ActiveRecord::Migration
  def change
    create_table :topic_collection_topicships do |t|
      t.integer :topic_collection_id
      t.integer :topic_id

      t.timestamps
    end
  end
end
