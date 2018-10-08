require 'handsome_fencer/circle_c_i/crypto'
require 'thor'

namespace :handsome_fencer do

  namespace :circle_c_i do

    class Hammer < Thor
      include Thor::Actions
    end

    desc "Sets up some necessary files for continuous deployments using docker and CircleCI"

    task :install do

      def copy_circle_templates
        directory "circleci", "./.circleci", recursive: true
      end

      exit
    end

    private

    def hammer(*args)
      Hammer.new.send *args
    end
  end
end
