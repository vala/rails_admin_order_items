class ItemsOrderIndex < ActiveRecord::Base
  scope :for_model, ->(name) { where(model_name: name) }
end
