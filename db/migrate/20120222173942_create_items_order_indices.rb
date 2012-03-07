class CreateItemsOrderIndices < ActiveRecord::Migration
  def change
    create_table :items_order_indices, :id => false do |t|
      t.string :model_name
      t.integer :item_id
      t.integer :item_index
    end
  end
end
