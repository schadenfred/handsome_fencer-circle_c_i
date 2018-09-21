require 'handsome_fencer/circle_c_i/crypto'
module HandsomeFencer
  module CircleCI

    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)
      desc "Sets up some necessary files for continuous deployments using docker and CircleCI"

      def copy_circle_templates
        directory ".circleci", ".circleci", recursive: true
      end

      def generate_deploy_key
        @cipher = Crypto.new
        @cipher.save_deploy_key
      end

      def insert_gitignores
        if File.exist? '.gitignore'
          append_to_file '.gitignore', "\n\.circle\/\*\*\/\*\.env"
          append_to_file '.gitignore', "\n.circle/**/*.key"
        end
      end
    end
  end
end
