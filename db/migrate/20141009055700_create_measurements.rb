class CreateMeasurements < ActiveRecord::Migration
  def change
    create_table :measurements do |t|
      t.integer :product_id
      t.string :title
      t.string :context_1
      t.string :context_2
      t.string :context_3
      t.string :context_4
      t.string :context_5
      t.string :context_6

      t.timestamps
    end
  end
end
