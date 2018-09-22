require 'test_helper'

class ObfuscateGeneratorTest < Rails::Generators::TestCase
  tests HandsomeFencer::CircleCI::ObfuscateGenerator

  destination File.expand_path("tmp", __dir__)
  setup :prepare_destination
  test "must be true" do
    run_generator ["handsome_fencer:circle_c_i:install"]
    run_generator ["handsome_fencer:circle_c_i:deploy_key"]
    run_generator ["handsome_fencer:circle_c_i:obfuscate"]
    File.exist? ".circleci/.env.enc"
    File.exist? ".circleci/containers/app/production.env.endc"
  end
end
