require 'handsome_fencer/circle_c_i/crypto'
module HandsomeFencer
  module CircleCI

    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)
      desc "Sets up some necessary files for continuous deployments using docker and CircleCI"

      def copy_circle_templates
        directory "circleci", ".circleci", recursive: true
      end

      def copy_deploy_task
        directory 'lib/', 'lib', recursive: true
      end

      def copy_docker_compose
        copy_file "docker-compose.yml", "docker-compose.yml"
      end

      def copy_config_databas_yml
        copy_file "config/database.yml", "config/database.yml"
      end


      def insert_gitignores
        create_file '.gitignore' if File.exist? '.gitignore'
        append_to_file '.gitignore', "\n.circleci/**/*.env"
        append_to_file '.gitignore', "\n.circleci/**/*.key"
      end
    end
  end
end
