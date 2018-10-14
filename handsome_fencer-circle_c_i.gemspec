$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "handsome_fencer/circle_c_i/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "handsome_fencer-circle_c_i"
  s.version     = HandsomeFencer::CircleCI::VERSION
  s.authors     = ["schadenfred"]
  s.email       = ["fred.schoeneman@gmail.com"]
  s.homepage    = "https://github.com/schadenfred/handsome_fencer-circle_c_i"
  s.summary     = "Handsome deployment of apps using CircleCI and Docker"
  s.description = "Obfuscate sensitive data in source control, expose it again for circle and then deploy"
  s.license     = "MIT"
  s.executables << 'handsome_fencer-circle_c_i'


  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "sshkit"
  s.add_dependency "thor"
  s.add_dependency "rake"

  s.add_development_dependency "minitest-given"
  s.add_development_dependency "rails"
  s.add_development_dependency "byebug"


end
