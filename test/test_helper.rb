ENV['RAILS_ENV'] ||= 'test'
# require_relative '../config/environment'
# require 'rails/test_help'
require "minitest"
require "minitest/autorun"
require "handsome_fencer/circle_c_i"
require "minitest/given"

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
