require 'activerecord'

module OpenMRS
  class Database
    attr_reader :environment, :options, :base_schema

    def initialize options = {}
      @environment     = ENV['RAILS_ENV'] || 'development'
      @options         = options
      @base_schema = 'db/migrations/00_base_schema.rb'
      # TODO: path to sql file
      # @sql_file = ''
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

    def self.logger
      @log ||= Logger.new('log/db.log')
    end

    def log
      self.class.logger
    end

    # TODO: load sql file into database
    def load_db
    end

    def dump
      log.info "Dumping base database migration to #{@base_schema}..."
      File.open(@base_schema, "w") do |file|
        ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
      end
    end

    def migration_file(index, table_name)
      index = "%02d" % index
      File.join('db','migrate', "#{index}_#{table_name}.rb")
    end

    def break_up_migration
      dump unless File.exists? @base_schema

      # open mega schema file
      table_definitions do |table_definition, index|
        table_name = table_definition.match(/create_table\s"(.*?)"/).first
        File.open(migration_file(index, table_name), "w") do |file|
          file.puts create_migration(table_name, table_definition)
        end
        # TODO: update the table if ActiveRecord::Base.connection.table_exists? table
      end
    end

    def table_definitions(&block)
      schema = File.read(@base_schema)
      definitions = []

      schema.scan(/(create_table.*?)(?=create_table|^end$)/mi) do |match|
        definitions << match.first
      end

      definitions.last.chop!
      definitions.last.chomp!('end')

      if block_given?
        definitions.each_with_index(&blocK)
      else
        definitions
      end
    end

    def create_migration table, statements
      contents = <<-EOM
      class Create#{table.camelize} < ActiveRecord::Migration
        def self.up
          #{statements}
        end

        def self.down
          drop_table :#{table}
        end
      end
      EOM
    end
  end
end

