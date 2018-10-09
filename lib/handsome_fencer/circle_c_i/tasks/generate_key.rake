require 'handsome_fencer/circle_c_i/crypto'
require 'thor'

namespace :handsome_fencer do

  class Hammer < Thor
    include Thor::Actions
  end

  namespace :circle_c_i do

    class Hammer < Thor
      include Thor::Actions
    end

    desc "generate deploy key"

    task :generate_key do

      if ARGV.include?('--rakefile')
        environment = ARGV[3]
        directory = ARGV[4]
      else
        environment = ARGV[1]
        directory = ARGV[2]
      end

      @cipher = OpenSSL::Cipher.new 'AES-128-CBC'
      @salt = '8 octets'
      @new_key = @cipher.random_key

      hammer :create_file, ".circleci/#{environment}.key", Base64.encode64(@new_key)

      exit
    end

  end
  private

  def hammer(*args)
    Hammer.new.send *args
  end
end
