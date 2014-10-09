class AddSomeAttrsColumnsToProducts < ActiveRecord::Migration
  def change

    add_column :products, :material, :text
    add_column :products, :wash, :text
    add_column :products, :model, :text
    
  end
end
