# RailsAdmin config file. Generated on February 22, 2012 18:23
# See github.com/sferik/rails_admin for more informations

RailsAdmin.config do |config|
  config.current_user_method { current_user } # auto-generated
  
  config.main_app_name = ['Dummy', 'Admin']
  
  config.actions do
    # root actions
    dashboard                     # mandatory
    # collection actions 
    index                         # mandatory
    new
    export
    history_index
    bulk_delete
    order_items
    # member actions
    show
    edit
    delete
    history_show
    show_in_app
  end
  
end
