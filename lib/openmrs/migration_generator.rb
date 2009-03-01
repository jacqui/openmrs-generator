require 'activerecord'

module OpenMRS
  class MigrationGenerator
    attr_accessor :environment, :base_schema, :sql_file, :database_yml

    def initialize(options = {})
      @environment    = ENV['RAILS_ENV'] || 'development'
      @base_schema    = options[:base_schema] || OpenMRS.basedir + '/db/migrate/00_base_schema.rb'
      @sql_file       = options[:sql] || OpenMRS.basedir + '/db/data/1.3.3-createdb-from-scratch-with-demo-data.sql'
      @database_yml   = options[:database_yml] || OpenMRS.basedir + '/config/database.yml'
      ActiveRecord::Base.establish_connection(config_options)
    end

    def config_options
      config = YAML::load_file(@database_yml)
      raise Exception("Missing database configuration for #{@environment} in #{@database_yml}") unless config.has_key?(@environment)
      config[@environment].symbolize_keys
    end

    def self.logger
      @log ||= Logger.new('log/db.log')
    end

    def log
      self.class.logger
    end

    def load_db
      password  = config_options[:password].blank? ? '' : "-p #{config_options[:password]}"
      host      = config_options[:host].blank? || config_options[:host] =~ /localhost|127\.0\.0\.0/ ? '' : "-h #{config_options[:host]}"

      cmd = "mysql -u#{config_options[:user]}"
      cmd += " #{host}" unless host.blank?
      cmd += " #{password}" unless password.blank?
      cmd += " < #{@sql_file}"
      `#{cmd}`
    end

    def dump
      log.info "Dumping base database migration to #{@base_schema}..."
      File.open(@base_schema, "w") do |file|
        ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
      end
    end

    def migration_file(table_name)
      time_str = Time.now.utc.strftime("%Y%m%d%H%M%S")
      File.join(OpenMRS.basedir, 'db','migrate', "#{time_str}_#{table_name}.rb")
    end

    def table_name_from(definition)
      if definition =~ /create_table\s"(.*?)"/
        $1
      else
        raise("Unable to extract table_name from #{definition}")
      end
    end

    def break_up_migration
      dump unless File.exists? @base_schema

      # open mega schema file
      table_definitions do |table_definition|
        table_name = table_name_from(table_definition)
        File.open(migration_file(table_name), "w+") do |file|
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
        definitions.each(&block)
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

