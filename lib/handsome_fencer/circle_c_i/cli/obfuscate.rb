
module HandsomeFencer
  module CircleCI
    class CLI < Thor

      desc "obfuscate", "obfuscate .env files inside"

      def obfuscate(*args)

        environment = args.first
        @cipher = HandsomeFencer::CircleCI::Crypto.new(environment: environment)
        @cipher.obfuscate('docker', "#{environment}.env")
      end
    end
  end
end
