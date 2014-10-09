class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :category_id
      t.string :name
      t.integer :price
      t.integer :price_for_sale
      t.string :status
      t.integer :article_id
      t.text :ck_context
      t.integer :ranking, :null => false, :default => 999

      t.timestamps
    end
  end
end
