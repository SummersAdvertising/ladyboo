class AddEnNameToProducts < ActiveRecord::Migration
  def change
    add_column :products, :en_name, :string
  end
end
