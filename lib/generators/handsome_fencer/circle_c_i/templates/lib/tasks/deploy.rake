# use SSHKit directly instead of Capistrano
require 'sshkit'
require 'sshkit/dsl'
include SSHKit::DSL

deploy_tag =      ENV['DEPLOY_TAG']
hostname =        ENV['SERVER_HOST']
user =            ENV['SERVER_USER']
dockerhub_user =  ENV['DOCKERHUB_USER']
dockerhub_pass =  ENV['DOCKERHUB_PASS']
port =            ENV['SERVER_PORT']
deploy_env =      ENV['DEPLOY_ENV'] || :production
deploy_path =     ENV['DEPLOY_PATH']

server = SSHKit::Host.new(hostname: hostname, port: port, user: user)

namespace :deploy do

  desc 'copy to server files needed to run and manage Docker containers'

  task :configs do

    on server do
      within deploy_path do
        upload! File.expand_path('../../config/containers/docker-compose.yml', __dir__), '.'
        upload! File.expand_path('../../.env', __dir__), '.', recursive: true
      end
    end
  end
end


namespace :docker do

  desc 'logs into Docker Hub for pushing and pulling'

  task :login do
    on server do
      execute "mkdir -p #{deploy_path}"
      within deploy_path do
        execute 'docker', 'login', '-u', dockerhub_user, '-p', dockerhub_pass
      end
    end
  end

  desc 'stops all Docker containers via Docker Compose'

  task stop: 'deploy:configs' do
    on server do
      within deploy_path do
        with rails_env: deploy_env, deploy_tag: deploy_tag do
          execute 'docker-compose', 'stop'

        end
      end
    end
  end

  desc 'starts all Docker containers via Docker Compose'

  task start: 'deploy:configs' do
    on server do
      within deploy_path do
        with rails_env: deploy_env, deploy_tag: deploy_tag do
          execute 'docker-compose', 'up', '-d'
          execute 'echo', deploy_tag , '>', 'deploy.tag'
        end
      end
    end
  end

  desc 'pulls images from Docker Hub'

  task pull: 'docker:login' do
    on server do
      within deploy_path do
        ["#{deploy_path}_app", "#{deploy_path}_web"].each do |image_name|
          execute 'docker', 'pull', "rennmappe/#{image_name}:#{deploy_tag}"
        end
        execute 'docker', 'pull', 'postgres:9.4.5'
      end
    end
  end


  desc 'runs database migrations in application container via Docker Compose'
  task migrate: 'deploy:configs' do
    on server do
      within deploy_path do
        with rails_env: deploy_env, deploy_tag: deploy_tag do
          execute 'docker-compose', 'run', 'app', "bin/rails", 'db:create', 'db:migrate'
        end
      end
    end
  end

  desc 'pulls images, stops old containers, updates the database, and starts new containers'
  task deploy: %w{docker:pull docker:stop docker:migrate docker:start }
end
