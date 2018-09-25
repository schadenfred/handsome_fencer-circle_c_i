require 'test_helper'
require 'fileutils'

Dir.chdir('test/dummy')

describe HandsomeFencer::CircleCI::Crypto do

  subject { HandsomeFencer::CircleCI::Crypto.new }

  Given do
    FileUtils.cp_r '../../lib/generators/handsome_fencer/circle_c_i/templates/.circleci', '.'
    open(deploy_key_file, "w") { |io| io.write(passkey) }
  end

  Given(:deploy_key_file) { '.circleci/deploy.key' }
  Given(:passkey) { "HidqS1dbAZXFDGiWGGk3Zw==" }

  Given { ENV['DEPLOY_KEY'] = passkey }

  describe "Manage deploy key" do

    describe "with ENV['DEPLOY_KEY'] set" do

      Given { File.delete deploy_key_file }
      Given { refute File.exist? deploy_key_file }
      Given(:pass_phrase) { subject.instance_variable_get("@pass_phrase") }

      Then { pass_phrase.must_equal Base64.decode64(passkey) }
    end

    describe "without ENV['DEPLOY_KEY'] set" do

      Given { ENV['DEPLOY_KEY'] = nil }

      describe "and without deploy key file" do

        Given { File.delete(deploy_key_file) }
        Given { refute File.exist? deploy_key_file }
        Given { assert ENV['DEPLOY_KEY'].nil? }

        describe "must raise error" do

          Given(:error) { HandsomeFencer::CircleCI::Crypto::DeployKeyError }

          Then { assert_raises(error) { subject } }
        end
      end

      describe "but with deploy key file" do

        Given { assert File.exist? deploy_key_file }
        Given { assert ENV['DEPLOY_KEY'].nil? }

        describe "must get pass_phrase from deploy key file" do

          Given(:pass_phrase) { subject.instance_variable_get("@pass_phrase") }

          Then { pass_phrase.must_equal Base64.decode64(passkey) }
        end
      end
    end
  end

  describe "expose and obfuscate methods" do

    Given(:env_file) { '.circleci/circle.env' }
    Given(:enc_file) { '.circleci/circle.env.enc' }
    Given(:nested_env_file) { '.circleci/containers/app/development.env' }
    Given(:nested_enc_file) { '.circleci/containers/app/development.env.enc' }
    Given(:env_files) { subject.source_files('.circleci', '.env') }
    Given(:enc_files) { subject.source_files('.circleci', '.enc') }

    Given { File.delete(enc_file) if File.exist?(enc_file) }
    Given { File.delete(nested_enc_file) if File.exist?(nested_enc_file) }
    Given { refute File.exist?(enc_file)  }
    Given { refute File.exist?(nested_enc_file)  }

    describe "#encrypt" do

      Given { subject.encrypt(env_file) }
      Given { subject.encrypt(nested_env_file) }

      Then { assert File.exist?(enc_file) }
      And  { assert File.exist?(nested_enc_file) }

      describe "#decrypt" do

        Given { File.delete(env_file) if File.exist?(env_file) }
        Given { File.delete(nested_env_file) if File.exist?(nested_env_file) }
        Given { refute File.exist?(env_file)  }
        Given { refute File.exist?(nested_env_file)  }

        When { subject.decrypt(enc_file) }
        When { subject.decrypt(nested_enc_file) }

        Then { assert File.exist?(env_file) }
        And  { assert File.exist?(nested_env_file) }
      end
    end

    describe "#source_files" do

      describe "with specified directory" do

        Then { env_files.must_include env_file }
        And  { env_files.must_include nested_env_file }
      end
    end

    describe "#obfuscate()" do

      Given { refute File.exist? enc_file }
      Given { refute File.exist? nested_enc_file }

      When  { subject.obfuscate }

      Then { assert File.exist? enc_file }
      And  { assert File.exist? nested_enc_file }

      describe "#expose()" do

        Given { subject.obfuscate }
        Given { env_files.each { |file| File.delete file } }
        Given { refute File.exist? env_file }
        Given { refute File.exist? nested_env_file }

        When { subject.expose }

        describe "must expose encrypted file" do

          Given(:expected) { "export DOCKERHUB_PASS" }

          Then { assert File.exist? env_file }
          And  { File.read(env_file).must_match expected  }
        end

        describe "must expose nested encrypted file" do

          Given(:expected) { "DATABASE_HOST" }

          Then { assert File.exist? nested_env_file }
          And  { File.read(nested_env_file).must_match expected  }
        end
      end
    end
  end

  Minitest.after_run do
    FileUtils.remove_dir('.circleci') if Dir.exist?('.circleci')
  end
end
