require 'handsome_fencer/circle_c_i/crypto'
module HandsomeFencer
  module CircleCI

    class ExposedEnvFilesGenerator < Rails::Generators::Base
      desc "expose .env files inside .circleci directory"

      source_root File.expand_path('templates', __dir__)
      class_option :environment, type: :string, default: 'deploy'

      def expose_env_files
        environment = options[:environment]
        @cipher = HandsomeFencer::CircleCI::Crypto.new(dkfile: environment)
        @cipher.expose('.circleci', "#{environment}.env.enc")
      end
    end
  end
end
