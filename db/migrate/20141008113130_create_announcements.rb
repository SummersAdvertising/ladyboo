class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.string :title
      t.string :subtitle
      t.integer :ranking, :null => false, :default => 999
      t.string :status
      t.integer :article_id
      t.string :type

      t.timestamps
    end
  end
end
