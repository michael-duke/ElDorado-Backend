class CreateCarStatusHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :car_status_histories do |t|
      t.references :car, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :from_status
      t.string :to_status
      t.text :notes

      t.timestamps
    end
  end
end
