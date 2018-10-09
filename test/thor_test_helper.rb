require 'test_helper'


Dir.chdir('tmp')

def destination_root
  File.join(Dir.pwd, 'test/tmp')
end

def prepare_destination
  FileUtils.rm_rf('.')
end
