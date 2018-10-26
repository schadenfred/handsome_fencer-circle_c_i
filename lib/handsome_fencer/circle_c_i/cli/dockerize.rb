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
        append_to_file "docker/containers/database/development.env", "something"
      end
    end
  end
end
