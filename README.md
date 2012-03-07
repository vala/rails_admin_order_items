# RailsAdmin Order Items

This gem is a custom collection action for Rails Admin that permits items reordering for your models from the admin, and getting them back with in the right order inside your frontend.

## Usage

In your Gemfile :

```ruby
gem "rails_admin_order_items", :git => "git@github.com:vala/rails_admin_order_items.git"
```

Bundle and install migration and migrate :

```bash
bundle install
rake rails_admin_order_items_engine:install:migrations
rake db:migrate
```

In your Rails Admin initializer : config/initializers/rails_admin.rb

```ruby
RailsAdmin.config do |config|
  # Add actions config block
  config.actions do
    dashboard
    index
    new
    export
    history_index
    bulk_delete
    show
    edit
    delete
    history_show
    show_in_app
    # Add the order_items action
    order_items
  end
end
```

Reboot your server if it was running, and now you got a "Reorder ModelName" tab alongside "List", "Add new" etc. action tabs in the index view of your models. You can order your models by dragging them or by typing an index in the dedicated input and pressing _Enter_ key

To call the ordered model items, just use `YourModel.ordered_items`
Note : Because of the way ordering is handled for now, you get back an array from this method and not an ActiveRecord::Relation object

E.g. : 

```ruby
class PicturesController < ApplicationController
  def index
    @pics = Picture.ordered_items
  end
end
```