require 'thor_test_helper'
require 'handsome_fencer/circle_c_i/cli/install'

describe "HandsomeFencer::CircleCI::CLI" do

  # Dir.chdir('tmp')
  #
  # def destination_root
  #   File.join(Dir.pwd, 'test/tmp')
  # end
  #
  # def prepare_destination
  #   FileUtils.rm_rf('.')
  # end

  Given { prepare_destination }
  Given(:subject) { HandsomeFencer::CircleCI::CLI.new }

  When { subject.generate_key('massiveattack') }

  Then { assert File.exist? '.circleci/keys/massiveattack.key' }
end

# tests HandsomeFencer::CircleCI::DeployKeyGenerator
#
# destination File.expand_path("tmp", __dir__)
# setup :prepare_destination
# test "must be true" do
#   run_generator ["handsome_fencer:circle_c_i:deploy_key"]
#   assert_file ".circleci/deploy.key", /\=\=/
# end
