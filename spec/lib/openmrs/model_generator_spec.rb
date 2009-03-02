require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe 'OpenMRS::Model' do
  before do
    OpenMRS.basedir = File.expand_path(File.dirname(__FILE__) + '/../../rails_root')
    @table_defs     = File.read("#{fixtures_dir}/table_definition.sql")
    @encounter_def, @user_def = @table_defs.split('-- SEPARATOR')
    @model          = OpenMRS::Model.new(@encounter_def)
  end

  describe '#table_name_from' do
    it 'returns the table name from the sql' do
      @model.table_name.should == 'encounter'
    end
  end

  it 'returns name of model based on table name' do
    @model.model_name.should == 'Encounter'
  end

  it '#primary_key' do
    @model.primary_key.should == 'encounter_id'
  end

  describe '#belongs_to' do
    before do
      @belongs_to = @model.belongs_to
    end

    it 'returns an array of association hashes' do
      @belongs_to.first.should be_a_kind_of(Hash)
    end

    describe 'individual association' do
      before do
        @bt = @belongs_to.first
      end

      it 'has required key => value pairs' do
        @bt[:table].should == 'encounter'
        @bt[:name].should == 'encounter_patient'
        @bt[:foreign_key].should == 'patient_id'
        @bt[:ref_table].should == 'patient'
        @bt[:ref_column].should == 'patient_id'
      end
    end
  end

  describe '#has_many' do
    before do
      @belongs_to = @model.belongs_to
      @user_model = OpenMRS::Model.new(@user_def)
      @hm_associations = @user_model.has_many(@belongs_to)
      @hm = @hm_associations.first
    end

    it 'returns an array of association hashes' do
      @hm.should be_a_kind_of(Hash)
    end

    it 'finds encounter relationships' do
      @hm[:table].should == @model.table_name
      @hm[:foreign_key].should == 'creator'
      @hm[:name].should == "encounter_users"
    end
  end
end
