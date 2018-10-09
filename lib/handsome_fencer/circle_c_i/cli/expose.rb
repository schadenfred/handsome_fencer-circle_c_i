module HandsomeFencer
  module CircleCI
    class CLI < Thor

      desc "expose", "expose .env files inside .circleci directory"

      def expose(*args)
        environment = args.first
        @cipher = HandsomeFencer::CircleCI::Crypto.new(environment: environment)
        @cipher.expose('.circleci', "#{environment}.env.enc")
      end
    end
  end
end
