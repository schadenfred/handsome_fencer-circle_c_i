require 'handsome_fencer/circle_c_i/crypto'
module HandsomeFencer
  module CircleCI

    class ExposedEnvFilesGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)
      desc "expose .env files inside .circleci directory"

      def expose_env_files
        @cipher = HandsomeFencer::CircleCI::Crypto.new
        @cipher.expose
      end
    end
  end
end
