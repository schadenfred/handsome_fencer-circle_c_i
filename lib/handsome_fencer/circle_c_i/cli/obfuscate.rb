
module HandsomeFencer
  module CircleCI
    class CLI < Thor

      desc "obfuscate", "obfuscates any files matching the pattern ./docker/**/*.env"

      def obfuscate(*args)

        default_environments = %w[circleci development production]
        environments = args.first ? args.first : default_environments
        environments.each do |environment|
          @cipher = HandsomeFencer::CircleCI::Crypto.new(environment: environment)
          @cipher.obfuscate('docker', "#{environment}.env")
        end
      end
    end
  end
end
