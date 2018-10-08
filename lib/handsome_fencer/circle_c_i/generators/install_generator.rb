require 'thor'
require 'thor/group'

class HandsomeFencer::CircleCI::Generator < Thor::Group
  include Thor::Actions
  desc 'Generate a new filesystem structure'
end
