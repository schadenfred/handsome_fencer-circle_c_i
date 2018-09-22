require 'test_helper'

class DeployKeyGeneratorTest < Rails::Generators::TestCase
  tests HandsomeFencer::CircleCI::DeployKeyGenerator

  destination File.expand_path("tmp", __dir__)
  setup :prepare_destination
  test "must be true" do
    run_generator ["handsome_fencer:circle_c_i:deploy_key"]
    assert_file ".circleci/deploy.key"
  end
end
