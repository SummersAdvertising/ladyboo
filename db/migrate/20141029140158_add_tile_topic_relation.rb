class AddTileTopicRelation < ActiveRecord::Migration
  def change
    add_column :tiles, :topic_id, :integer
  end
end
