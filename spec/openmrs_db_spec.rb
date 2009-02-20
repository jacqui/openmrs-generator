require 'mocha'
require 'lib/openmrs/db'

describe 'OpenMRS::Database' do

  describe 'instantiating a new object' do
    it 'sets default env to development' do
      OpenMRS::Database.new.environment.should == 'development'
    end

    it 'sets enviroment to RAILS_ENV' do
      ENV['RAILS_ENV'] = 'production'
      OpenMRS::Database.new.environment.should == 'production'
      ENV['RAILS_ENV'] = nil
    end

    it 'raises an exception if database.yml missing config for environment' do
      ENV['RAILS_ENV'] = 'staging'
      lambda { OpenMRS::Database.new }.should raise_error
      ENV['RAILS_ENV'] = nil
    end

    it 'sets base_schema' do
      OpenMRS::Database.new.base_schema.should == 'db/migrations/00_base_schema.rb'
    end

    it 'establishes a connection to the db' do
      ActiveRecord::Base.expects(:establish_connection).at_least_once
      OpenMRS::Database.new
    end
  end

  describe '#dump' do
    before do
      #ActiveRecord::Base.stubs(:establish_connection)
      #ActiveRecord::SchemaDumper.stubs(:dump)
      @db = OpenMRS::Database.new
    end

    it 'generate a migration file' do
      @db.dump
      contents = File.read(@db.base_schema)
      contents.should_not be_nil
    end
  end

  describe '#table_definitions' do
    before do
      fixtures_dir = File.expand_path(File.dirname(__FILE__) + '/fixtures')
      @base_schema = File.read("#{fixtures_dir}/00_base_schema.rb")
      @db = OpenMRS::Database.new
    end

    it "returns an array of strings" do
      @db.table_definitions.should be_a_kind_of(Array)
      @db.table_definitions.first.should be_a_kind_of(String)
    end

    it "returns 72 tables" do
      @db.table_definitions.size.should == 72
    end
  end

  describe '#create_migration' do
    before do
      @db = OpenMRS::Database.new
    end

    it 'wraps statements in a migration' do
      @db.create_migration('concept_class', 'some statements').should =~ /class CreateConceptClass/
    end
  end

  describe '#migration_file' do
    before do
      @db = OpenMRS::Database.new
    end

    it 'returns a filename' do
      @db.migration_file(1, 'concept_class').should == 'db/migrate/01_concept_class.rb'
    end
  end
end
