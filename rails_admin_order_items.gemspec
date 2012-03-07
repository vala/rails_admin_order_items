$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails_admin_order_items/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails_admin_order_items"
  s.version     = RailsAdminOrderItems::VERSION
  s.authors     = ["Valentin Ballestrino"]
  s.email       = ["vala@glyph.fr"]
  s.homepage    = "http://github.com/vala/rails_admin_order_items"
  s.summary     = "Rails admin plugin giving the ability to easily reorder items in the list view table"
  s.description = "Rails admin plugin giving the ability to easily reorder items in the list view table"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 3.1"
  # s.add_dependency "rails_admin", '~> 0.0.1'

  s.add_development_dependency "mysql2"
end
