require 'handsome_fencer/circle_c_i/crypto'
module HandsomeFencer
  module CircleCI

    class ObfuscateGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)
      desc "obfuscate .env and .key files inside .circleci directory"

      def obfuscate_env_files
        @cipher = HandsomeFencer::CircleCI::Crypto.new
        @cipher.obfuscate
      end
    end
  end
end
