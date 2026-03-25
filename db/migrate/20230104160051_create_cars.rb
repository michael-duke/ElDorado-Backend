class CreateCars < ActiveRecord::Migration[7.0]
  def change
    create_table :cars do |t|
      t.string :name
      t.string :image
      t.string :model
      t.decimal :daily_price, precision: 10, scale: 2
      t.text :description
      t.string :status, default: 'available', null: false
  
      t.timestamps
    end

    add_index :cars, :status
  end
end
