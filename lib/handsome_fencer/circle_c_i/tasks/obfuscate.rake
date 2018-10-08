require 'handsome_fencer/circle_c_i/crypto'
require 'thor'
namespace :handsome_fencer do

  namespace :circle_c_i do

    desc "Generaters necessary files for CI using Circle, Docker, and Rails"

    task :obfuscate do

      environment = ARGV[0].nil? ? 'deploy' : ARGV[0]
      directory = ARGV[1].nil? ? '.circleci' : ARGV[1]

      @cipher = HandsomeFencer::CircleCI::Crypto.new(dkfile: environment)
      @cipher.obfuscate(directory, environment)
    end
  end
end
