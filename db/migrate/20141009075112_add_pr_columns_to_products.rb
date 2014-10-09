class AddPrColumnsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :highlight, :string
    add_column :products, :is_new, :string
  end
end
