module RailsAdminOrderItems
  class Engine < ::Rails::Engine
    initializer "RailsAdminOrderItems precompile hook" do |app|
      app.config.assets.precompile += ['rails_admin/order_items.js']
    end
  end
end