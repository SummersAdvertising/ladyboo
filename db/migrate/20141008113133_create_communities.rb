class CreateCommunities < ActiveRecord::Migration
  def change
    create_table :communities do |t|
      t.string :title
      t.string :subtitle
      t.text :ck_context
      t.integer :ranking, :null => false, :default => 999
      t.string :status
      t.integer :article_id
      t.string :type

      t.timestamps
    end
  end
end
