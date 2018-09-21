require 'rails/generators'
require_relative '../../../lib/generators/handsome_fencer/circle_c_i/install_generator.rb'

class HandsomeFencer::CircleCI::InstallGeneratorTest < Rails::Generators::TestCase
  tests HandsomeFencer::CircleCI::InstallGenerator

  destination File.expand_path("tmp", __dir__)
  setup :prepare_destination
  test "must be true" do
    run_generator ["handsome_fencer:circle_c_i:install"]
    assert_file ".circleci/.env"
    assert_file ".circleci/deploy.key"
    assert_file ".gitignore", /\.circleci\/\*\*\/\*.env/
    assert_file ".gitignore", /\.circleci\/\*\*\/\*.key/
    assert_file "lib/tasks/deploy.rake"
  end
end
