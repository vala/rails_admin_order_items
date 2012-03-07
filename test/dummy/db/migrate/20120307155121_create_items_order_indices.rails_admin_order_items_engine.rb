# This migration comes from rails_admin_order_items_engine (originally 20120222173942)
class CreateItemsOrderIndices < ActiveRecord::Migration
  def change
    create_table :items_order_indices, :id => false do |t|
      t.string :model_name
      t.integer :item_id
      t.integer :item_index
    end
  end
end
