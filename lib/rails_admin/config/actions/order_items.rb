require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdmin
  module Config
    module Actions
      class OrderItems < Base
        RailsAdmin::Config::Actions.register(self)
        
        register_instance_option :collection do
          true
        end

        register_instance_option :http_methods do
          [:get, :post]
        end

        register_instance_option :route_fragment do
          'order-items'
        end

        register_instance_option :visible? do
          authorized? rescue false
        end
        
        register_instance_option :template_name do
          :order_items
        end
        
        register_instance_option :link_icon do
          'icon-move'
        end
        
        register_instance_option :controller do
          Proc.new do
            to_model = lambda {|s| s.singularize.camelize.constantize}
            if request.xhr? && params[:order_model_name]
              if params[:order_action] == 'order_page' && params[:order_indexes]
                sort = RailsAdminOrderItems::Models::ItemsOrderIndex.sort_ordered_model_items(to_model.call(params[:order_model_name]), params[:order_indexes].to_a.map(&:last)) 
              elsif params[:order_action] == 'place_item' && params[:item_data]
                sort = RailsAdminOrderItems::Models::ItemsOrderIndex.place_item(to_model.call(params[:order_model_name]), params[:item_data][:id].to_i, params[:item_data][:index].to_i)
              end
            end


            @objects ||= list_entries
            @ordered_items = RailsAdminOrderItems::Models::ItemsOrderIndex.get_ordered_items(@abstract_model.to_param.camelize.constantize, 'ASC', :page => (params[:page] || 1).to_i, :per => (params[:per] || @model_config.list.items_per_page).to_i)

            respond_to do |format|
              format.html do
                render @action.template_name, :layout => !request.xhr?, :status => (flash[:error].present? ? :not_found : 200)
              end
            end
          end
        end

        
      end
    end
  end
end

