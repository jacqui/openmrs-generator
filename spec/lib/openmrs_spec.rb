require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'OpenMRS' do

  before do
    OpenMRS.basedir = File.expand_path(File.dirname(__FILE__) + '/../../rails_root')
  end

  it 'sets default env' do
    OpenMRS.environment.should == 'test'
  end

  describe '#config_options' do
    it 'reads from config/database.yml' do
      OpenMRS.config_options[:database].should == 'openmrs_test'
    end
  end
end

