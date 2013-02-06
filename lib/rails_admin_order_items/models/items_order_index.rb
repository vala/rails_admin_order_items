module RailsAdminOrderItems
  module Models
    module ItemsOrderIndex
      class << self
        def get_ordered_items model, direction = 'ASC', user_options = {}
          options = {:page => 0, :per => 40}.merge user_options
          # Get the model name
          model_name = model.to_s
          # Sort the whole model entries if not every record is found
          self.sort_model! model if model.count > ActiveRecord::Base.connection.execute("SELECT COUNT(*) FROM items_order_indices WHERE model_name='#{model_name}'").first.first
          # Find all items from the desired model ordered by their 'item_index'
          mdls = self.get_items(model, direction, options)
        end

        # Used to ensure the model has a default sorting when unordered items are found and items are retrieved with ::get_ordered_items method
        def sort_model! model
          # We get existing models in the indexes table
          existing = self.get_items(model, 'ASC')
          # iteration variable to set indexes after the last existent one
          n = existing.length - 1
          # We sort the new items
          sort_ordered_model_items model, (n <= 0 ? model.all : model.select(:id).where('id NOT IN (?)', existing.map(&:id))).map {|item| {:id => item.id, :index => (n += 1)}}
        end

        def sort_ordered_model_items model, order_list
          # Get the model name
          model_name = model.to_s
          # Get all yet ordered ids in our order table
          ids_in_table = ActiveRecord::Base.connection.execute("SELECT 'item_id' FROM items_order_indices WHERE 'model_name'='#{model_name}'").map {|a| a[0]}

          order_list.each do |item|
            # Update item index if id already in table
            if ids_in_table.include?(item[:id].to_i)
              ActiveRecord::Base.connection.execute("UPDATE items_order_indices SET 'item_index'=#{item[:index]} WHERE 'model_name'='#{model_name}' AND 'item_id'='#{item[:id]}'")
            # If the item does not exist, insert it
            else
              ActiveRecord::Base.connection.execute("INSERT INTO items_order_indices ('model_name', 'item_id', 'item_index') VALUES ('#{model_name}', '#{item[:id]}', '#{item[:index]}')")
            end
          end
        end

        # Place an item from an index, used when index is filled in input field
        def place_item model, id, new_index
          # Get items list
          items = self.get_items(model, 'ASC')
          # Get item from id in list
          item = items.delete_at(items.index {|i| i.id == id})
          # Reorder items placing our newly indexed item
          reordered_items = new_index > items.length ? items.push(item) : new_index < 0 ? items.unshift(item) : items.insert(new_index, item)
          # Save ordered items
          n = -1
          sort_ordered_model_items model, reordered_items.map {|i| {:id => i.id, :index => (n += 1)}}
        end

        #
        def get_items(model, direction, user_options = {})
          options = {:page => 0, :per => 40}.merge user_options
          model_name = model.to_s
          limit_statement = options[:page] > 0 ? " LIMIT #{options[:per] * (options[:page] - 1)},#{options[:per]}" : ''
          model.find_by_sql("SELECT #{model.table_name}.* FROM #{model.table_name} LEFT JOIN items_order_indices ON #{model.table_name}.id=items_order_indices.item_id WHERE 'model_name'='#{model_name}' AND '#{Time.now.to_f}' > 0 ORDER BY items_order_indices.item_index #{direction}#{limit_statement}")
        end
      end
    end
  end
end
