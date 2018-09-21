require 'handsome_fencer/circle_c_i/crypto'
module HandsomeFencer
  module CircleCI

    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)
      desc "Sets up some necessary files for continuous deployments using docker and CircleCI"

      def copy_circle_templates
        directory ".circleci", ".circleci", recursive: true
      end

      def copy_deploy_task
        file = 'lib/tasks/deploy.rake'
        copy_file file, file
      end


      def generate_deploy_key

        @cipher = OpenSSL::Cipher.new 'AES-128-CBC'
        @salt = '8 octets'
        @new_key = @cipher.random_key

        create_file ".circleci/deploy.key", Base64.encode64(@new_key)

      end

      def insert_gitignores
        create_file '.gitignore'
        append_to_file '.gitignore', "\n.circleci/**/*.env"
        append_to_file '.gitignore', "\n.circleci/**/*.key"
      end
    end
  end
end
