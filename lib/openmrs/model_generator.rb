require 'activerecord'

module OpenMRS
  class ModelGenerator
  end

  class Model
    include OpenMRS

    attr_reader :table_name, :model_name

    def initialize(schema)
      # 1. figure out the name of the model
      # 2. find associations using foreign keys
      # 3. define validations based on column defs
      @schema       = schema
      @table_name   = table_name_from_schema
      @model_name   = ActiveRecord::Base.class_name @table_name
#      @constraints  = constraints_from(schema)
    end

    def table_name_from_schema
      if @schema =~ /CREATE TABLE\s`(.*?)`/
        $1
      else
        raise("Unable to extract model name from #{@schema}")
      end

    end

    def primary_key
      if @schema =~ /PRIMARY KEY\s+\(`(.*?)`\)/
        $1
      else
        raise("Unable to extract primary key from #{@schema}")
      end
    end

    def belongs_to
      belongs_to = []

      @schema.scan(/CONSTRAINT `(.*?)` FOREIGN KEY \(`(.*?)`\) REFERENCES `(.*?)` \(`(.*?)`\)([^,]*)/).each do |m|
        belongs_to << { :name        => m[0],
                        :table       => @table_name,
                        :foreign_key => m[1], 
                        :ref_table   => m[2],
                        :ref_column  => m[3]
                      }

      end
      belongs_to
    end

    def has_many(belongs_to_associations)
      has_many = []
      belongs_to_associations.select do |association|
        association[:ref_table] == @table_name
      end.map do |association| 
        has_many << { :table        => association[:table],
                      :foreign_key  => association[:foreign_key],
                      :name         => has_many_name(association)
                    }
      end
      has_many
    end

    def has_many_name(association)
      return association[:name] unless association[:name] =~ /ibfk/
      "#{association[:table]}_#{association[:ref_table].pluralize}"
    end
  end
end

