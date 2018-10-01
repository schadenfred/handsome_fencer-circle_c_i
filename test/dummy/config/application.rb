require_relative 'boot'

# active_record is what we're not going to use it, so comment it "just in case"
# require "active_record/railtie"

# This is not loaded in rails/all but inside active_record so add it if
# you want your models work as expected
# require "active_model/railtie"
# And now the rest
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"
Bundler.require(*Rails.groups)
require "handsome_fencer/circle_c_i"

module Dummy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
