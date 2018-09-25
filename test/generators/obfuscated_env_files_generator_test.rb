require 'rails/generators'
require 'generators/handsome_fencer'

class ObfuscatedEnvFilesGeneratorTest < Rails::Generators::TestCase
  tests HandsomeFencer::CircleCI::ObfuscatedEnvFilesGenerator

  destination File.expand_path("tmp", __dir__)
  setup :prepare_destination
  test "must be true" do
    ENV['DEPLOY_KEY']
    assert_no_file '.circleci/.env.enc'
    assert_no_file ".circleci/containers/app/production.env.enc"
    run_generator ["handsome_fencer:circle_c_i:deploy_key"]
    run_generator ["handsome_fencer:circle_c_i:install"]
    run_generator ["handsome_fencer:circle_c_i:obfuscated_env_files"]
    assert_file ".circleci/.env.enc"
    assert_file ".circleci/containers/app/production.env.enc"
  end
end
