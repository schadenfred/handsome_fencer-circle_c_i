require 'handsome_fencer/circle_c_i/crypto'
module HandsomeFencer
  module CircleCI

    class ObfuscatedEnvFilesGenerator < Rails::Generators::Base

      class_option :environment, type: :string, default: 'deploy'

      source_root File.expand_path('templates', __dir__)
      desc "obfuscate .env files inside .circleci directory"

      def obfuscate_env_files

        environment = options[:environment]

        @cipher = HandsomeFencer::CircleCI::Crypto.new(dkfile: environment)
        @cipher.obfuscate('.circleci', "#{environment}.env")
      end
    end
  end
end
