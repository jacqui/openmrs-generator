require 'activerecord'

module OpenMRS
  class << self
    attr_accessor :basedir, :environment, :database_yml

    def config_options
      config = YAML::load_file(@database_yml)
      raise Exception("Missing database configuration for #{@environment} in #{@database_yml}") unless config.has_key?(@environment)
      config[@environment].symbolize_keys
    end

    def logger
      @log ||= Logger.new('log/db.log')
    end

    def mysql_cli
      password  = config_options[:password].blank? ? '' : "-p #{config_options[:password]}"
      host      = config_options[:host].blank? || config_options[:host] =~ /localhost|127\.0\.0\.0/ ? '' : "-h #{config_options[:host]}"

      cmd = "mysql -u#{config_options[:user]}"
      cmd += " #{host}" unless host.blank?
      cmd += " #{password}" unless password.blank?
      cmd
    end
  end

  def log
    OpenMRS.logger
  end

  def mysql_cli
    OpenMRS.mysql_cli
  end

  self.basedir      = File.expand_path(File.dirname(__FILE__) + '/../')
  self.environment  = ENV['RAILS_ENV'] || 'development'
  self.database_yml = basedir + '/config/database.yml'
  ActiveRecord::Base.establish_connection(config_options)
end

require "openmrs/migration_generator"
require "openmrs/model_generator"

