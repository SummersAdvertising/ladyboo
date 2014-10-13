class AddStatusAndLimitToLookbooks < ActiveRecord::Migration
  def change
    add_column :lookbooks, :status, :string, default: 'disable'
    add_column :lookbooks, :limit, :integer, default: 1

    add_column :topic_collections, :status, :string, default: 'disable'
    add_column :topic_collections, :limit, :integer, default: 1
  end
end
