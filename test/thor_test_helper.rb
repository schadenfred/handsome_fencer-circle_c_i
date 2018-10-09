require 'test_helper'


def prepare_destination

  if  Dir.pwd.split('/').last == "handsome_fencer-circle_c_i"
    Dir.chdir('test/tmp')
  end
  FileUtils.rm_rf('.')
end
