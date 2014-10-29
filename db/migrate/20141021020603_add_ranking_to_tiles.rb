class AddRankingToTiles < ActiveRecord::Migration
  def change
    add_column :tiles, :ranking, :integer, default: 999
  end
end
