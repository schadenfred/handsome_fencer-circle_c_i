module HandsomeFencer
  module CircleCI
    class Railtie < ::Rails::Railtie
      rake_tasks do
        load 'tasks/handsome_fencer/circle_c_i_tasks.rake'
      end
    end
  end
end
