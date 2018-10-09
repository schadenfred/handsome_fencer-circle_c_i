require 'thor'
require 'handsome_fencer/circle_c_i/cli/install'
require 'handsome_fencer/circle_c_i/cli/generate_key'
require 'handsome_fencer/circle_c_i/cli/obfuscate'
require 'handsome_fencer/circle_c_i/cli/expose'

module HandsomeFencer
  module CircleCI
    class CLI < Thor

      include Thor::Actions

      def self.source_root
        File.dirname(__FILE__) + '/templates/'
      end
    end
  end
end
