module HandsomeFencer
  module Install

    class CircleCIGenerator < Rails::Generators::Base
      source_root File.expand_path('../../templates', __dir__)
      desc "Sets up some necessary files for continuous deployments using docker and CircleCI"
      def copy_circle_templates
        directory ".circleci", "./.circle", recursive: true
      end
    end
  end
end
