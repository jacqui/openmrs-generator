module OpenMRS
  class << self
    attr_accessor :basedir
  end

  self.basedir = File.expand_path(File.dirname(__FILE__) + '/../')
end

require "openmrs/migration_generator"

