require 'handsome_fencer/circle_c_i/crypto'
module HandsomeFencer
  module CircleCI

    class DeployKeyGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)
      desc "generate deploy key"

      class_option :environment, type: :string, default: 'deploy'
      def generate_deploy_key
        environment = options[:environment]
        @cipher = OpenSSL::Cipher.new 'AES-128-CBC'
        @salt = '8 octets'
        @new_key = @cipher.random_key

        create_file ".circleci/#{environment}.key", Base64.encode64(@new_key)
      end
    end
  end
end

# desc 'copy keys to server'
# task :environment_keys, [:source, :destination] do |task, args|
#
#   on server do
#     within deploy_path do
#       destination = args[:destination] || '.'
#       upload! File.expand_path("../../#{args[:source]}", __dir__), destination='.'
#     end
#   end
# end
