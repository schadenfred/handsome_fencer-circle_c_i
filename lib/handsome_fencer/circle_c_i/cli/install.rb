module HandsomeFencer
  module CircleCI
    class CLI < Thor

      desc "install", "This will generate a .circleci directory in your project root, along with a set of files for continuous deployments using docker and CircleCI"

      def install
        directory "circleci", "./.circleci", recursive: true
        directory "lib/", "lib", recursive: true
        copy_file "docker-compose.yml", "docker-compose.yml"
        copy_file "Gemfile", "Gemfile" unless File.exist? "Gemfile"
        copy_file "Gemfile.lock", "Gemfile.lock" unless File.exist? "Gemfile.lock"
        copy_file "config/database.yml", "config/database.yml"
        copy_file "gitignore", ".gitignore" unless File.exist? ".gitignore"
        append_to_file ".gitignore", "\n.circleci/**/*.env"
        append_to_file ".gitignore", "\n.circleci/**/*.key"
      end
    end
  end
end
