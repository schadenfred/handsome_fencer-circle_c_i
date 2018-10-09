require 'byebug'

module HandsomeFencer
  module CircleCI
    class CLI < Thor

      desc "obfuscate", "obfuscate .env files inside .circleci directory"

      def obfuscate(*args)

        environment = args.first
        @cipher = HandsomeFencer::CircleCI::Crypto.new(environment: environment)
        @cipher.obfuscate('.circleci', "#{environment}.env")
      end
    end
  end
end
