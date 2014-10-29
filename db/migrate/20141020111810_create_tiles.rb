class CreateTiles < ActiveRecord::Migration
  def change
    create_table :tiles do |t|
      t.integer :lookbook_id
      t.string :context_1
      t.string :context_2
      t.string :context_3
      t.string :context_4
      t.string :context_5

      t.timestamps
    end
  end
end
