class AddIdToItemsOrderIndices < ActiveRecord::Migration
  def change
    add_column :items_order_indices, :id, :primary_key
  end
end
