require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe 'OpenMRS::MigrationGenerator' do
  before do
    OpenMRS.basedir = File.expand_path(File.dirname(__FILE__) + '/../../rails_root')
    @generator = OpenMRS::MigrationGenerator.new
  end

  describe 'instantiating a new object' do
    it 'sets default env' do
      @generator.environment.should == 'test'
    end

    it 'sets enviroment to RAILS_ENV' do
      ENV['RAILS_ENV'] = 'production'
      OpenMRS::MigrationGenerator.new.environment.should == 'production'
      ENV['RAILS_ENV'] = 'test'
    end

    it 'raises an exception if database.yml missing config for environment' do
      ENV['RAILS_ENV'] = 'staging'
      lambda { OpenMRS::MigrationGenerator.new }.should raise_error
      ENV['RAILS_ENV'] = 'test'
    end

    it 'sets base_schema' do
      OpenMRS::MigrationGenerator.new.base_schema.should =~ %r|db/migrate/00_base_schema.rb|
    end

    it 'establishes a connection to the db' do
      ActiveRecord::Base.expects(:establish_connection).at_least_once
      OpenMRS::MigrationGenerator.new
    end

    describe '#config_options' do
      it 'reads from config/database.yml' do
        @generator.config_options[:database].should == 'openmrs_test'
      end
    end

  end

  describe '#load_db' do
    it 'loads the sql file into the db' do
      @generator.load_db
      ActiveRecord::Base.connection.tables.should include('concept','drug','encounter')
    end
  end

  describe '#dump' do
    it 'generate a migration file' do
      @generator.dump
      contents = File.read(@generator.base_schema)
      contents.should_not be_nil
    end
  end

  describe '#table_definitions' do
    it "returns an array of strings" do
      @generator.table_definitions.should be_a_kind_of(Array)
      @generator.table_definitions.first.should be_a_kind_of(String)
    end

    it "returns 72 tables" do
      @generator.table_definitions.size.should == 72
    end
  end

  describe '#table_name_from' do
    before do
      @definition =<<-EOL
        create_table "cohort", :primary_key => "cohort_id", :force => true do |t|
          t.string   "name", :null => false
          t.string   "description", :limit => 1000
          t.integer  "creator", :null => false
        end
        EOL
    end

    it 'returns the table name' do
      @generator.table_name_from(@definition).should == 'cohort'
    end
  end

  describe '#create_migration' do
    it 'wraps statements in a migration' do
      @generator.create_migration('concept_class', 'some statements').should =~ /class CreateConceptClass/
    end
  end

  describe '#migration_file' do
    it 'returns a filename' do
      @generator.migration_file('concept_class').should =~ %r|db/migrate/(\d{14})_concept_class.rb|
    end
  end

end
