$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "handsome_fencer/circle_c_i/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "handsome_fencer-circle_c_i"
  s.version     = HandsomeFencer::CircleCI::VERSION
  s.authors     = ["schadenfred"]
  s.email       = ["fred.schoeneman@gmail.com"]
  s.homepage    = "https://github.com/schadenfred/handsomefencer-environment"
  s.summary     = "Deploy Handsome Rails apps using Circle"
  s.description = "Obfuscate sensitive data in source control, expose it again for circle and then deploy"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.2.1"

  s.add_development_dependency "sqlite3"
end
