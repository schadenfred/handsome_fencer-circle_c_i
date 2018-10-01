require 'openssl'
require 'base64'
require 'byebug'

module HandsomeFencer
  module CircleCI
    class Crypto

      DeployKeyError = Class.new(StandardError)

      def initialize(options={})
        @cipher = OpenSSL::Cipher.new 'AES-128-CBC'
        @salt = '8 octets'
        @dkfile = options[:dkfile] ? ('.circleci/' + options[:dkfile] + '.key') : dkfile
        @pass_phrase = get_deploy_key
      end

      def get_deploy_key
        case
        when ENV['DEPLOY_KEY'].nil? && !File.exist?(@dkfile)
          raise DeployKeyError, "No deploy key set. Please generate a deploy key using '$ bin/rails generate handsome_fencer:circle_c_i:deploy_key' or set it using '$ export ENV['DEPLOY_KEY'] = some-complicated-key'"
        when File.exist?(@dkfile)
          Base64.decode64(File.read(@dkfile))
        when !ENV['DEPLOY_KEY'].nil?
          Base64.decode64(ENV['DEPLOY_KEY'])
        end
      end

      def read_deploy_key
        File.exist?(dkfile) ? File.read(dkfile) : save_deploy_key
      end

      def save_deploy_key

        @new_key = @cipher.random_key

        write_to_file Base64.encode64(@new_key), dkfile
        # ignore_sensitive_files
        read_deploy_key
      end

      def ignore_sensitive_files
        if File.exist? '.gitignore'
          ["/#{dkfile}", "/.env/*"].each do |pattern|
            unless File.read('.gitignore').match pattern
              open('.gitignore', 'a') { |f| f << pattern }
            end
          end
        end
      end

      def encrypt(file)
        file = file
        @cipher.encrypt.pkcs5_keyivgen @pass_phrase, @salt
        encrypted = @cipher.update(File.read file) + @cipher.final
        write_to_file(Base64.encode64(encrypted), file + '.enc')
      end

      def decrypt(file)
        encrypted = Base64.decode64 File.read(file)
        @cipher.decrypt.pkcs5_keyivgen @pass_phrase, @salt
        decrypted = @cipher.update(encrypted) + @cipher.final
        decrypted_file = file.split('.enc').first
        write_to_file decrypted, decrypted_file
      end

      def source_files(directory=nil, extension=nil)
        Dir.glob(directory + "/**/*#{extension}")
      end

      def obfuscate(directory=nil, extension=nil)
        extension = extension || '.env'
        directory = directory || '.circleci'
        source_files(directory, extension).each { |file| encrypt file }
      end

      def expose(directory=nil, extension=nil)
        extension = extension || '.env.enc'
        directory = directory || '.circleci'
        source_files(directory, extension).each { |file| decrypt(file) }
      end

      private

        def dkfile
          ".circleci/deploy.key"
        end

        def write_to_file(data, filename)
          File.open(filename, "w") { |io| io.write data }
        end
    end
  end
end
