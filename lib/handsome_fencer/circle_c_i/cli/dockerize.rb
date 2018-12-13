require 'byebug'

module HandsomeFencer
  module CircleCI

    class CLI < Thor

      desc "dockerize", "This will generate files necessary to dockerize your project, along with a set of files for continuous deployment using CircleCI"

      def dockerize

        directory "circleci", "./.circleci", recursive: true
        directory "docker", "docker", recursive: true
        directory "lib", "lib", recursive: true
        copy_file "docker-compose.yml", "docker-compose.yml"
        copy_file "Gemfile", "Gemfile"
        copy_file "Gemfile.lock", "Gemfile.lock"
        copy_file "config/database.yml", "config/database.yml"
        copy_file "gitignore", ".gitignore"
        append_to_file ".gitignore", "\ndocker/**/*.env"
        append_to_file ".gitignore", "\ndocker/**/*.key"

        prompts = {
          "APP_NAME" => "the name of your app",
          "SERVER_HOST" => "the ip address of your server",
          "DOCKERHUB_EMAIL" => "your Docker Hub email",
          "DOCKERHUB_USER" => "your Docker Hub username",
          "POSTGRES_USER" => "your Postgres username",
          "POSTGRES_PASSWORD" => "your Postgres password",
          "DOCKERHUB_PASS" => "your Docker Hub password"
        }

        prompts.map do |key, prompt|
          prompts[key] = ask("Please provide #{prompt}:")
        end

        account_type = ask("Will you be pushing images to Docker Hub under your user name or under your organization name instead?", :limited_to => %w[org user])
        if account_type == "org"
          prompts['DOCKERHUB_ORG_NAME']= ask("Organization name:")
        else
          prompts['DOCKERHUB_ORG_NAME']= "${DOCKERHUB_USER}"
        end

        prompts.map do |key, value|
          append_to_file 'docker/env_files/circleci.env', "\nexport #{key}=#{value}"
        end

        %w[development circleci staging production].each do |environment|
          base = "docker/containers/"

          app_env = create_file "#{base}app/#{environment}.env"
          append_to_file app_env, "DATABASE_HOST=database\n"
          append_to_file app_env, "RAILS_ENV=#{environment}\n"

          database_env = create_file "#{base}database/#{environment}.env"
          append_to_file database_env, "POSTGRES_USER=postgres\n"
          append_to_file database_env, "POSTGRES_DB=#{prompts['APP_NAME']}_#{environment}\n"
          append_to_file database_env, "POSTGRES_PASSWORD=#{prompts['POSTGRES_PASSWORD']}\n"

          ssl = (environment == "production") ? true : false
          web_env = create_file "#{base}web/#{environment}.env"
          append_to_file web_env, "CA_SSL=postgres#{ssl}\n"
        end
        %w[circleci production].each do |environment|
          template "docker/overrides/#{environment}.yml.tt", "docker/overrides/#{environment}.yml"
        end

        %w[app web].each do |container|
          options = {
            email: prompts['DOCKERHUB_EMAIL'],
            app_name: prompts['APP_NAME']
          }
          template "docker/containers/#{container}/Dockerfile.tt", "docker/containers/#{container}/Dockerfile", options
        end
      end
    end
  end
end
