class CreateTopicCollections < ActiveRecord::Migration
  def change
    create_table :topic_collections do |t|
      t.string :name

      t.timestamps
    end
  end
end
