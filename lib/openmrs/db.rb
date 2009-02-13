require 'activerecord'

module OpenMRS
  class Database
    attr_reader :environment, :options, :migrations_root, :base_db_schema

    def initialize options = {}
      @environment     = ENV['RAILS_ENV'] || 'development'

      @options         = options
      @migrations_root = 'db/migrations/'
      Dir.mkdir @migrations_root  unless File.exists? @migrations_root
      @base_db_schema = @migrations_root + '00_base_schema.rb'

      ActiveRecord::Base.establish_connection(config_options)
    end

    def config_options
      if !@options.blank?
        { :adapter => @options[:adapter],
          :host    => @options[:host],
          :username => @options[:username],
          :password => @options[:password],
          :database => @options[:database]
        }
      elsif File.exists? 'config/database.yml'
        config = YAML::load_file('config/database.yml')
        raise Exception("Missing database configuration for #{@environment} in config/database.yml") unless config.has_key?(@environment)
        config[@environment]
      else
        { :adapter  => "mysql",
          :host     => "localhost",
          :username => "root",
          :password => "",
          :database => "openmrs_dev" }
      end
    end

    def dump
      puts "Dumping base database migration to #{@base_db_schema}..."
      File.open(@base_db_schema, "w") do |file|
        ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
      end
    end

  end
end

