require 'handsome_fencer/circle_c_i/crypto'
module HandsomeFencer
  module CircleCI

    class DeployKeyGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)
      desc "generate deploy key"


      def generate_deploy_key
        @cipher = OpenSSL::Cipher.new 'AES-128-CBC'
        @salt = '8 octets'
        @new_key = @cipher.random_key

        create_file ".circleci/deploy.key", Base64.encode64(@new_key)
      end
    end
  end
end
