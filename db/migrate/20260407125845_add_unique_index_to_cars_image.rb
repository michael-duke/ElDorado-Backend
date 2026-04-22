class AddUniqueIndexToCarsImage < ActiveRecord::Migration[7.1]
  def change
    add_index :cars, :image, unique: true
  end
end