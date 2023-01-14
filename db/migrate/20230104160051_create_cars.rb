class CreateCars < ActiveRecord::Migration[7.0]
  def change
    create_table :cars do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :image
      t.string :model
      t.decimal :daily_price
      t.text :description
      t.boolean :available, default: true 
  
      t.timestamps
    end
  end
end
