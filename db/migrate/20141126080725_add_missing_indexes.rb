class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :orderlogs, :order_id
    add_index :stocks, :product_id
    add_index :tiles, :lookbook_id
    add_index :tiles, :topic_id
    add_index :communities, :article_id
    add_index :communities, [:id, :type]
    add_index :galleries, [:attachable_id, :attachable_type]
    add_index :galleries, [:id, :type]
    add_index :topic_collection_topicships, :topic_collection_id
    add_index :topic_collection_topicships, :topic_id
    add_index :topic_productships, :topic_id
    add_index :topic_productships, :product_id
    add_index :topic_productships, [:product_id, :topic_id]
    add_index :lookbook_topicships, :lookbook_id
    add_index :lookbook_topicships, :topic_id
    add_index :measurements, :product_id
    add_index :orderitems, :order_id
    add_index :orderasks, :order_id
    add_index :photos, :article_id
    add_index :addressbooks, :user_id
    add_index :announcements, :article_id
    add_index :announcements, [:id, :type]
    add_index :pickups, :product_id
    add_index :products, :category_id
    add_index :products, :article_id
    add_index :categories, :parent_id
    add_index :orders, :user_id
  end
end