require 'byebug'

module HandsomeFencer
  module CircleCI
    class CLI < Thor

      desc "generate_key", "(Re)generate a key for each environment"

      def generate_key(*args)
        environment = args.first

        @cipher = OpenSSL::Cipher.new 'AES-128-CBC'
        @salt = '8 octets'
        @new_key = @cipher.random_key

        create_file ".circleci/keys/#{environment}.key", Base64.encode64(@new_key)
      end
    end
  end
end
