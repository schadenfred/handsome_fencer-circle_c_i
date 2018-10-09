module HandsomeFencer
  module CircleCI
    class CLI < Thor

      desc "install", "This will generate a .circleci directory in your project root, along with a set of files for continuous deployments using docker and CircleCI"


      def getsome( name )
        greeting = "Hello, #{name}"
        greeting.upcase! if options[:upcase]
        puts greeting
      end
      # class Hn < Thor
      #   desc "search URL", "Search hn.algolia.com for a url mentioned on Hackernews"
      #   option :tags
      #   def search( url )
      #     puts "Looks like you are looking for #{url} with tags #{options[:tags]}"
      #   end
      # end
    end
  end
end
