require File.expand_path('../models/items_order_index', __FILE__)

module RailsAdminOrderItems
  module Models
  end
end

ActiveRecord::Base.class_eval do
  
  def self.ordered_items direction = 'ASC', options = {}
    RailsAdminOrderItems::Models::ItemsOrderIndex.get_ordered_items self.model_name.constantize, direction, options
  end
  
end