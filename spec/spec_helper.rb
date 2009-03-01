ENV["RAILS_ENV"] = "test"

require 'spec'
require 'mocha'
$: << File.expand_path(File.dirname(__FILE__) + '/../lib/')
require 'openmrs'

def fixtures_dir
  File.expand_path(File.dirname(__FILE__) + '/fixtures')
end
