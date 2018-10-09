require 'thor_test_helper'

describe "HandsomeFencer::CircleCI::CLI" do

  Given { prepare_destination }

  Given(:subject) { HandsomeFencer::CircleCI::CLI.new }

  Given { subject.install }
  Given { subject.generate_key('circle') }
  Given { subject.obfuscate('circle') }

  describe "install" do

    Then { assert File.exist? '.circleci/circle.env' }
    And  { assert File.exist? '.circleci/config.yml' }
    And  { assert File.exist? 'config/database.yml' }
    And  { assert File.exist? 'docker-compose.yml' }
  end

  describe "generate_key" do

    Then { assert File.exist? '.circleci/keys/circle.key' }
    And  { assert File.exist? '.circleci/keys/circle.key' }
  end

  describe "staging environment" do

    Given { refute File.exist? '.circleci/containers/app/staging.env.enc' }
    Given { refute File.exist? '.circleci/containers/database/staging.env.enc' }
    Given { subject.generate_key('staging') }
    Given { subject.obfuscate('staging') }

    Then { assert File.exist? '.circleci/containers/app/staging.env.enc' }
    And  { assert File.exist? '.circleci/containers/database/staging.env.enc' }
  end
end
