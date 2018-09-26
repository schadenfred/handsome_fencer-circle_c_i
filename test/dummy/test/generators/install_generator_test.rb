require 'rails/generators'
require 'generators/handsome_fencer'

class InstallGeneratorTest < Rails::Generators::TestCase
  tests HandsomeFencer::CircleCI::InstallGenerator

  destination File.expand_path("tmp", __dir__)
  setup :prepare_destination
  test "must be true" do
    run_generator ["handsome_fencer:circle_c_i:install"]
    assert_file ".circleci/circle.env"
    assert_file "docker-compose.yml"
    assert_file ".gitignore", /\.circleci\/\*\*\/\*.env/
    assert_file ".gitignore", /\.circleci\/\*\*\/\*.key/
    assert_file "lib/tasks/deploy.rake"
  end
end
