module HandsomeFencer
  module CircleCI
    class CLI < Thor

      desc "dockerize", "This will generate files necessary to dockerize your project, along with a set of files for continuous deployment using CircleCI"

      def dockerize
        directory "circleci", "./.circleci", recursive: true
        directory "docker", "docker", recursive: true
        directory "lib", "lib", recursive: true
        copy_file "docker-compose.yml", "docker-compose.yml"
        copy_file "Gemfile", "Gemfile" unless File.exist? "Gemfile"
        copy_file "Gemfile.lock", "Gemfile.lock" unless File.exist? "Gemfile.lock"
        copy_file "config/database.yml", "config/database.yml"
        copy_file "gitignore", ".gitignore" unless File.exist? ".gitignore"
        append_to_file ".gitignore", "\ndocker/**/*.env"
        append_to_file ".gitignore", "\ndocker/**/*.key"

        app_name = ask("Name of your app:")
        append_to_file 'docker/env_files/circleci.env', "\nexport APP_NAME=#{app_name}"

        append_to_file 'docker/containers/database/development.env', "\nPOSTGRES_DB=#{app_name}_development"
        append_to_file 'docker/containers/database/production.env', "\nPOSTGRES_DB=#{app_name}_production"
        {
          "SERVER_HOST" => "ip address of your server:",
          "DOCKERHUB_EMAIL" => "You'll need an account with Docker hub.docker.com. Please provide your Docker email:",
          "DOCKERHUB_USER" => "Please provide your Docker username here:",
          "DOCKERHUB_PASS" => "Please provide your Docker password here:"
        }.each do |env_var, prompt|
          variable_value = ask(prompt)
          append_to_file 'docker/env_files/circleci.env', "\nexport #{env_var}=#{variable_value}"
        end
        account_type = ask("Will you like to push your images to Docker under user account or organization instead?", :limited_to => %w[o, u])
        if account_type == "o"
          org_name = ask("Organization name:")
          append_to_file 'docker/env_files/circleci.env', "\nexport DOCKERHUB_ORG_NAME=#{org_name}"
        else
          append_to_file 'docker/env_files/circleci.env', "\nexport DOCKERHUB_ORG_NAME=${DOCKERHUB_USER}"
        end
        {
          "APP_NAME" => "Name of your app:"
        }.each do |env_var, prompt|
          app_name = ask(prompt)
          template "docker/overrides/docker-compose.production.yml.tt", "docker/overrides/docker-copose.produciton.yml"
        end
      end
    end
  end
end
