class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.integer :parent_id
      t.string :name
      t.integer :depth

      t.timestamps
    end
  end
end
