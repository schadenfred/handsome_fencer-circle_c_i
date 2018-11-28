module HandsomeFencer
  module CircleCI
    class CLI < Thor
      map "generate_keys" => "generate_key"
      desc "generate_key", "(Re)generate a key for each environment"

      def generate_key(*args)
        default_environments = %w[circleci development production]
        environments = args.first ? [args.first] : default_environments
        environments.each do |environment|
          @cipher = OpenSSL::Cipher.new 'AES-128-CBC'
          @salt = '8 octets'
          @new_key = @cipher.random_key

          create_file "docker/keys/#{environment}.key", Base64.encode64(@new_key)
        end
      end
    end
  end
end
