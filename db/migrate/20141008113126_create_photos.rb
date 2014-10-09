class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :image
      t.string :name
      t.integer :article_id

      t.timestamps
    end
  end
end
