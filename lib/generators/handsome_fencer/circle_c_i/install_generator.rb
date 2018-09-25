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
        directory 'lib/', 'lib', recursive: true
      end

      def insert_gitignores
        create_file '.gitignore'
        append_to_file '.gitignore', "\n.circleci/**/*.env"
        append_to_file '.gitignore', "\n.circleci/**/*.key"
      end
    end
  end
end
