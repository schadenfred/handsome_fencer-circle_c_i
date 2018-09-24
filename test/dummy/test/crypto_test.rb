require 'test_helper'
require 'handsome_fencer/circle_c_i/crypto'

Dir.chdir('test/dummy') do
describe HandsomeFencer::CircleCI::Crypto do

  Given(:deploy_key_file) { '.circleci/deploy.key' }
  Given(:passkey) { "HidqS1dbAZXFDGiWGGk3Zw==" }

  subject { HandsomeFencer::CircleCI::Crypto.new }

  describe "#get_deploy_key" do

    describe "with ENV['DEPLOY_KEY'] set" do

      Given(:passkey) { "env-file-passkey"}
      Given(:pass_phrase) { subject.instance_variable_get("@pass_phrase") }
      Given { ENV['DEPLOY_KEY'] = passkey }

      Then { pass_phrase.must_equal Base64.decode64("env-file-passkey") }
    end

    describe "without ENV['DEPLOY_KEY'] set" do

      Given { ENV['DEPLOY_KEY'] = nil }

      describe "and without deploy key file" do

        Given { File.delete(deploy_key_file) if File.exist?(deploy_key_file) }

        Given(:custom_error) {HandsomeFencer::CircleCI::Crypto::DeployKeyError }

        describe "must raise error" do

          Then { assert_raises(custom_error) { subject } }
        end
      end

      describe "but with deploy key file" do

        Given(:passkey) { "deploy-key-file-passkey"}
        Given { open(Rails.root.join(deploy_key_file), "w") { |io| io.write(passkey) } }
        Then { assert File.exist?(Rails.root.join(deploy_key_file)) }
        # And { assert_equal File.read(deploy_key_file), passkey}
        # Given(:pass_phrase) { subject.instance_variable_get("@pass_phrase") }
        # Then { pass_phrase.must_equal Base64.decode64(passkey) }
      end
    end
  end

  Given(:env_file)        { '.circleci/.env' }
  Given(:nested_env_file) { '.circleci/containers/app/production.env'}

  describe "#encrypt" do

    # Given { ENV['DEPLOY_KEY'] = passkey }
    # Given(:env_enc_file) { '.circleci/.env.enc' }
    # Given { subject.encrypt env_file }
    #
    # Then { assert File.exist? env_enc_file }

    describe "#decrypt" do

      # Given { File.delete env_file}
      # Given { subject.decrypt env_enc_file }
      # Given(:actual) { File.read env_file }
      # Given(:expected) { File.read env_file }
      #
      # Then { assert File.exist? env_file }
      # And { assert_equal actual, expected }
    end
  end

  describe "#source_files" do

    describe "default" do

      # Given { ENV['DEPLOY_KEY'] = passkey }
      # Given { open(env_file, "w") { |io| io.write("export some key") } }
      # Given { open(nested_env_file, "w") { |io| io.write("export some key") } }
      #
      # Given(:circle_env_files) { subject.source_files('.circleci', '.env') }
      #
      # Then { File.exist?(env_file) }
      # And { circle_env_files.must_include Rails.root.join(env_file) }
      # And  { env_files.must_include nested_env_file }
    end

    describe "with specified directory" do

      # Given(:env_files) { subject.source_files('.env', '.env') }
      #
      # Then { env_files.must_include env_file }
      # And  { env_files.must_include nested_env_file }
    end
  end

  describe "#obfuscate()" do

    # Given { subject.obfuscate }
    #
    # Then { assert File.exist? env_file + '.enc' }
    # And  { assert File.exist? nested_env_file + '.enc' }
  end

  describe "#expose" do

    # Given { subject.obfuscate }
    # Given { File.delete env_file }
    # Given { File.delete nested_env_file }
    # Given { subject.expose }
    #
    # Then { assert File.exist? env_file }
    # And  { assert File.exist? nested_env_file }
  end

  # Minitest.after_run do
  #   samples = [
  #     '.circleci/.env',
  #     '.circleci/containers/app/development.env',
  #     '.circleci/containers/app/production.env'
  #   ]
  #   samples.each do |file|
  #     FileUtils.copy('lib/generators/handsome_fencer/circle_c_i/templates/.circleci/.env', "test/dummy/#{file}")
  #   end
  # end
end
end
