class CreateLookbooks < ActiveRecord::Migration
  def change
    create_table :lookbooks do |t|
      t.string :name

      t.timestamps
    end
  end
end
