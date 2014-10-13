class CreateTopicProductships < ActiveRecord::Migration
  def change
    create_table :topic_productships do |t|
      t.integer :topic_id
      t.integer :product_id

      t.timestamps
    end
  end
end
