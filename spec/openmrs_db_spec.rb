require 'mocha'
require 'lib/openmrs/db'

describe 'OpenMRS::Database' do

  before do
  end

  describe 'instantiating a new object' do
    before do
    end

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

    it 'sets migrations_root' do
      OpenMRS::Database.new.migrations_root.should == 'db/migrations/'
    end

    it 'sets base_db_schema' do
      OpenMRS::Database.new.base_db_schema.should == 'db/migrations/00_base_schema.rb'
    end

    it 'establishes a connection to the db' do
      #ActiveRecord::Base.expects(:establish_connection)
      #OpenMRS::Database.new
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
      contents = File.read(@db.base_db_schema)
      contents.should_not be_nil
    end
  end
end
