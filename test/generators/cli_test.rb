require 'thor_test_helper'

describe "HandsomeFencer::CircleCI::CLI" do

  Given(:subject) { HandsomeFencer::CircleCI::CLI.new }

  Given { prepare_destination }
  Given { subject.install }

  describe "install" do

    Then { assert File.exist? '.circleci/circle.env' }
    And { assert File.exist? '.circleci/containers/app/Dockerfile' }
    And { assert File.exist? '.circleci/containers/app/development.env' }
    And { assert File.exist? '.circleci/containers/database/development.env' }
    And { assert File.exist? '.circleci/overrides/production.yml' }
    And { assert File.exist? '.circleci/config.yml' }
    And { assert File.exist? 'config/database.yml' }
    And { assert File.exist? 'docker-compose.yml' }
    And { assert File.exist? 'lib/tasks/deploy.rake' }
    And { assert File.exist? 'Gemfile' }
    And { assert File.exist? '.gitignore' }
  end

  describe "generate_key" do

    Given { subject.generate_key('circle') }

    Then { assert File.exist? '.circleci/keys/circle.key' }
  end

  describe "obfuscate" do

    Then { refute File.exist? '.circleci/keys/circle.key' }

    describe "with ENV['CIRCLE_KEY'] set" do

      Given(:passkey) { "HidqS1dbAZXFDGiWGGk3Zw==" }
      Given { ENV['CIRCLE_KEY'] = passkey }
      Given { subject.obfuscate('circle') }

      Then { assert File.exist? '.circleci/circle.env.enc' }
    end

    describe "ENV['CIRCLE_KEY'] = nil " do

      Given { ENV['CIRCLE_KEY'] = nil }
      Given { assert ENV['CIRCLE_KEY'].nil? }

      describe "without dkfile" do

        Given { refute File.exist? '.circleci/keys/circle.key' }

        describe "must raise error" do

          Given(:error) { HandsomeFencer::CircleCI::Crypto::DeployKeyError }

          Then { assert_raises(error) { subject.obfuscate('circle') } }
        end
      end

      describe "with dkfile" do

        Given { subject.generate_key('circle') }
        Given { subject.obfuscate('circle') }

        Then { assert File.exist? '.circleci/circle.env.enc' }

        describe "expose" do

          Given { File.delete('.circleci/circle.env') }
          Given { refute File.exist? '.circleci/circle.env' }
          Given { subject.expose('circle') }

          Then { assert File.exist? '.circleci/circle.env' }
        end
      end
    end

    describe "staging" do

      Given { refute File.exist? '.circleci/containers/app/staging.env.enc' }
      Given { subject.generate_key('staging') }
      Given { subject.obfuscate('staging') }

      Then { assert File.exist? '.circleci/containers/database/staging.env.enc' }

      describe "expose" do

        Given { File.delete '.circleci/containers/database/staging.env' }
        Given { refute File.exist? '.circleci/containers/database/staging.env' }
        Given { subject.expose('staging') }

        Then { assert File.exist? '.circleci/containers/database/staging.env' }
      end
    end
  end
end
