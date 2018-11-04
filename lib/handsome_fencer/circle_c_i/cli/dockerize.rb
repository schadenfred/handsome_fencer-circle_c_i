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
        append_to_file ".gitignore", "docker/**/*.env"
        append_to_file ".gitignore", "docker/**/*.key"

        app_name = ask("Name of your app:")
        append_to_file 'docker/env_files/circleci.env', "\nexport APP_NAME=#{app_name}"

        append_to_file 'docker/containers/database/development.env', "\nPOSTGRES_DB=#{app_name}_development"
        append_to_file 'docker/containers/database/production.env', "\nPOSTGRES_DB=#{app_name}_production"

        {
          "SERVER_HOST" => "ip address of your server",
          "DOCKERHUB_EMAIL" => "You will need an account with Docker, which can be created at hub.docker.com. Once you have your account, please provide the email associated with it here:",
          "DOCKERHUB_USER" => "Please provide your Docker username here:",
          "DOCKERHUB_PASS" => "Please provide your Docker password here:"
        }.each do |env_var, prompt|
          variable_value = ask(prompt)
          append_to_file 'docker/env_files/circleci.env', "\nexport #{env_var}=#{variable_value}"
        end
        account_type = ask("Are your images associated with your user name or an organization?", :limited_to => %w[organization user])
        if account_type = "organization"
          org_name = ask("Organization name:")
          append_to_file 'docker/env_files/circleci.env', "\nexport DOCKERHUB_ORG_NAME=#{org_name}"
        else
          append_to_file 'docker/env_files/circleci.env', "\nexport DOCKERHUB_ORG_NAME=${DOCKERHUB_USER}"
        end
      end
    end
  end
end
