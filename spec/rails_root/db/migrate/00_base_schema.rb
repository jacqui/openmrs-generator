# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 0) do

  create_table "cohort", :primary_key => "cohort_id", :force => true do |t|
    t.string   "name",                         :null => false
    t.string   "description",  :limit => 1000
    t.integer  "creator",                      :null => false
    t.datetime "date_created",                 :null => false
    t.boolean  "voided",                       :null => false
    t.integer  "voided_by"
    t.datetime "date_voided"
    t.string   "void_reason"
    t.integer  "changed_by"
    t.datetime "date_changed"
  end

  add_index "cohort", ["changed_by"], :name => "user_who_changed_cohort"
  add_index "cohort", ["creator"], :name => "cohort_creator"
  add_index "cohort", ["voided_by"], :name => "user_who_voided_cohort"

  create_table "cohort_member", :id => false, :force => true do |t|
    t.integer "cohort_id",  :default => 0, :null => false
    t.integer "patient_id", :default => 0, :null => false
  end

  add_index "cohort_member", ["cohort_id"], :name => "cohort"
  add_index "cohort_member", ["patient_id"], :name => "patient"

  create_table "complex_obs", :primary_key => "obs_id", :force => true do |t|
    t.integer "mime_type_id",                        :default => 0, :null => false
    t.text    "urn"
    t.text    "complex_value", :limit => 2147483647
  end

  add_index "complex_obs", ["mime_type_id"], :name => "mime_type_of_content"

  create_table "concept", :primary_key => "concept_id", :force => true do |t|
    t.boolean  "retired",                      :default => false, :null => false
    t.string   "short_name"
    t.text     "description"
    t.text     "form_text"
    t.integer  "datatype_id",                  :default => 0,     :null => false
    t.integer  "class_id",                     :default => 0,     :null => false
    t.boolean  "is_set",                       :default => false, :null => false
    t.integer  "creator",                      :default => 0,     :null => false
    t.datetime "date_created",                                    :null => false
    t.integer  "default_charge"
    t.string   "version",        :limit => 50
    t.integer  "changed_by"
    t.datetime "date_changed"
    t.integer  "retired_by"
    t.datetime "date_retired"
    t.string   "retire_reason"
  end

  add_index "concept", ["changed_by"], :name => "user_who_changed_concept"
  add_index "concept", ["class_id"], :name => "concept_classes"
  add_index "concept", ["creator"], :name => "concept_creator"
  add_index "concept", ["datatype_id"], :name => "concept_datatypes"
  add_index "concept", ["retired_by"], :name => "user_who_retired_concept"

  create_table "concept_answer", :primary_key => "concept_answer_id", :force => true do |t|
    t.integer  "concept_id",     :default => 0, :null => false
    t.integer  "answer_concept"
    t.integer  "answer_drug"
    t.integer  "creator",        :default => 0, :null => false
    t.datetime "date_created",                  :null => false
  end

  add_index "concept_answer", ["answer_concept"], :name => "answer"
  add_index "concept_answer", ["concept_id"], :name => "answers_for_concept"
  add_index "concept_answer", ["creator"], :name => "answer_creator"

  create_table "concept_class", :primary_key => "concept_class_id", :force => true do |t|
    t.string   "name",          :default => "",    :null => false
    t.string   "description",   :default => "",    :null => false
    t.integer  "creator",       :default => 0,     :null => false
    t.datetime "date_created",                     :null => false
    t.boolean  "retired",       :default => false, :null => false
    t.integer  "retired_by"
    t.datetime "date_retired"
    t.string   "retire_reason"
  end

  add_index "concept_class", ["creator"], :name => "concept_class_creator"
  add_index "concept_class", ["retired"], :name => "concept_class_retired_status"
  add_index "concept_class", ["retired_by"], :name => "user_who_retired_concept_class"

  create_table "concept_datatype", :primary_key => "concept_datatype_id", :force => true do |t|
    t.string   "name",                          :default => "",    :null => false
    t.string   "hl7_abbreviation", :limit => 3
    t.string   "description",                   :default => "",    :null => false
    t.integer  "creator",                       :default => 0,     :null => false
    t.datetime "date_created",                                     :null => false
    t.boolean  "retired",                       :default => false, :null => false
    t.integer  "retired_by"
    t.datetime "date_retired"
    t.string   "retire_reason"
  end

  add_index "concept_datatype", ["creator"], :name => "concept_datatype_creator"
  add_index "concept_datatype", ["retired"], :name => "concept_datatype_retired_status"
  add_index "concept_datatype", ["retired_by"], :name => "user_who_retired_concept_datatype"

  create_table "concept_derived", :primary_key => "concept_id", :force => true do |t|
    t.text     "rule",           :limit => 16777215
    t.datetime "compile_date"
    t.string   "compile_status"
    t.string   "class_name",     :limit => 1024
  end

  create_table "concept_map", :primary_key => "concept_map_id", :force => true do |t|
    t.integer  "source"
    t.integer  "source_id"
    t.string   "comment"
    t.integer  "creator",      :default => 0, :null => false
    t.datetime "date_created",                :null => false
    t.integer  "concept_id",   :default => 0, :null => false
  end

  add_index "concept_map", ["concept_id"], :name => "map_for_concept"
  add_index "concept_map", ["creator"], :name => "map_creator"
  add_index "concept_map", ["source"], :name => "map_source"

  create_table "concept_name", :primary_key => "concept_name_id", :force => true do |t|
    t.integer  "concept_id"
    t.string   "name",                       :default => "", :null => false
    t.string   "short_name"
    t.text     "description",                                :null => false
    t.string   "locale",       :limit => 50, :default => "", :null => false
    t.integer  "creator",                    :default => 0,  :null => false
    t.datetime "date_created",                               :null => false
  end

  add_index "concept_name", ["concept_id"], :name => "unique_concept_name_id"
  add_index "concept_name", ["concept_name_id"], :name => "concept_name_id", :unique => true
  add_index "concept_name", ["creator"], :name => "user_who_created_name"
  add_index "concept_name", ["name"], :name => "name_of_concept"
  add_index "concept_name", ["short_name"], :name => "short_name_of_concept"

  create_table "concept_numeric", :primary_key => "concept_id", :force => true do |t|
    t.float   "hi_absolute"
    t.float   "hi_critical"
    t.float   "hi_normal"
    t.float   "low_absolute"
    t.float   "low_critical"
    t.float   "low_normal"
    t.string  "units",        :limit => 50
    t.boolean "precise",                    :default => false, :null => false
  end

  create_table "concept_proposal", :primary_key => "concept_proposal_id", :force => true do |t|
    t.integer  "concept_id"
    t.integer  "encounter_id"
    t.string   "original_text",                :default => "",         :null => false
    t.string   "final_text"
    t.integer  "obs_id"
    t.integer  "obs_concept_id"
    t.string   "state",          :limit => 32, :default => "UNMAPPED", :null => false
    t.string   "comments"
    t.integer  "creator",                      :default => 0,          :null => false
    t.datetime "date_created",                                         :null => false
    t.integer  "changed_by"
    t.datetime "date_changed"
  end

  add_index "concept_proposal", ["changed_by"], :name => "user_who_changed_proposal"
  add_index "concept_proposal", ["concept_id"], :name => "concept_for_proposal"
  add_index "concept_proposal", ["creator"], :name => "user_who_created_proposal"
  add_index "concept_proposal", ["encounter_id"], :name => "encounter_for_proposal"
  add_index "concept_proposal", ["obs_concept_id"], :name => "proposal_obs_concept_id"
  add_index "concept_proposal", ["obs_id"], :name => "proposal_obs_id"

  create_table "concept_set", :id => false, :force => true do |t|
    t.integer  "concept_id",   :default => 0, :null => false
    t.integer  "concept_set",  :default => 0, :null => false
    t.float    "sort_weight"
    t.integer  "creator",      :default => 0, :null => false
    t.datetime "date_created",                :null => false
  end

  add_index "concept_set", ["concept_set"], :name => "has_a"
  add_index "concept_set", ["creator"], :name => "user_who_created"

  create_table "concept_set_derived", :id => false, :force => true do |t|
    t.integer "concept_id",  :default => 0, :null => false
    t.integer "concept_set", :default => 0, :null => false
    t.float   "sort_weight"
  end

  create_table "concept_source", :primary_key => "concept_source_id", :force => true do |t|
    t.string   "name",         :limit => 50, :default => "", :null => false
    t.text     "description",                                :null => false
    t.string   "hl7_code",     :limit => 50, :default => "", :null => false
    t.integer  "creator",                    :default => 0,  :null => false
    t.datetime "date_created",                               :null => false
    t.integer  "voided",       :limit => 1
    t.integer  "voided_by"
    t.datetime "date_voided"
    t.string   "void_reason"
  end

  add_index "concept_source", ["creator"], :name => "concept_source_creator"
  add_index "concept_source", ["voided_by"], :name => "user_who_voided_concept_source"

  create_table "concept_state_conversion", :primary_key => "concept_state_conversion_id", :force => true do |t|
    t.integer "concept_id",                :default => 0
    t.integer "program_workflow_id",       :default => 0
    t.integer "program_workflow_state_id", :default => 0
  end

  add_index "concept_state_conversion", ["concept_id"], :name => "triggering_concept"
  add_index "concept_state_conversion", ["program_workflow_id", "concept_id"], :name => "unique_workflow_concept_in_conversion", :unique => true
  add_index "concept_state_conversion", ["program_workflow_id"], :name => "affected_workflow"
  add_index "concept_state_conversion", ["program_workflow_state_id"], :name => "resulting_state"

  create_table "concept_synonym", :id => false, :force => true do |t|
    t.integer  "concept_id",   :default => 0,  :null => false
    t.string   "synonym",      :default => "", :null => false
    t.string   "locale"
    t.integer  "creator",      :default => 0,  :null => false
    t.datetime "date_created",                 :null => false
  end

  add_index "concept_synonym", ["concept_id"], :name => "synonym_for"
  add_index "concept_synonym", ["creator"], :name => "synonym_creator"

  create_table "concept_word", :id => false, :force => true do |t|
    t.integer "concept_id",               :default => 0,  :null => false
    t.string  "word",       :limit => 50, :default => "", :null => false
    t.string  "synonym",                  :default => "", :null => false
    t.string  "locale",     :limit => 20, :default => "", :null => false
  end

  add_index "concept_word", ["word"], :name => "word_in_concept_name"

  create_table "drug", :primary_key => "drug_id", :force => true do |t|
    t.integer  "concept_id",                       :default => 0,     :null => false
    t.string   "name",               :limit => 50
    t.boolean  "combination",                      :default => false, :null => false
    t.integer  "dosage_form"
    t.float    "dose_strength"
    t.float    "maximum_daily_dose"
    t.float    "minimum_daily_dose"
    t.integer  "route"
    t.string   "units",              :limit => 50
    t.integer  "creator",                          :default => 0,     :null => false
    t.datetime "date_created",                                        :null => false
    t.boolean  "retired",                          :default => false, :null => false
    t.integer  "retired_by"
    t.datetime "date_retired"
    t.datetime "retire_reason"
  end

  add_index "drug", ["concept_id"], :name => "primary_drug_concept"
  add_index "drug", ["creator"], :name => "drug_creator"
  add_index "drug", ["dosage_form"], :name => "dosage_form_concept"
  add_index "drug", ["retired_by"], :name => "user_who_voided_drug"
  add_index "drug", ["route"], :name => "route_concept"

  create_table "drug_ingredient", :id => false, :force => true do |t|
    t.integer "concept_id",    :default => 0, :null => false
    t.integer "ingredient_id", :default => 0, :null => false
  end

  add_index "drug_ingredient", ["concept_id"], :name => "combination_drug"

  create_table "drug_order", :primary_key => "order_id", :force => true do |t|
    t.integer "drug_inventory_id",     :default => 0
    t.float   "dose"
    t.float   "equivalent_daily_dose"
    t.string  "units"
    t.string  "frequency"
    t.boolean "prn",                   :default => false, :null => false
    t.boolean "complex",               :default => false, :null => false
    t.integer "quantity"
  end

  add_index "drug_order", ["drug_inventory_id"], :name => "inventory_item"

  create_table "encounter", :primary_key => "encounter_id", :force => true do |t|
    t.integer  "encounter_type"
    t.integer  "patient_id",         :default => 0,     :null => false
    t.integer  "provider_id",        :default => 0,     :null => false
    t.integer  "location_id",        :default => 0,     :null => false
    t.integer  "form_id"
    t.datetime "encounter_datetime",                    :null => false
    t.integer  "creator",            :default => 0,     :null => false
    t.datetime "date_created",                          :null => false
    t.boolean  "voided",             :default => false, :null => false
    t.integer  "voided_by"
    t.datetime "date_voided"
    t.string   "void_reason"
  end

  add_index "encounter", ["creator"], :name => "encounter_creator"
  add_index "encounter", ["encounter_type"], :name => "encounter_type_id"
  add_index "encounter", ["form_id"], :name => "encounter_form"
  add_index "encounter", ["location_id"], :name => "encounter_location"
  add_index "encounter", ["patient_id"], :name => "encounter_patient"
  add_index "encounter", ["provider_id"], :name => "encounter_provider"
  add_index "encounter", ["voided_by"], :name => "user_who_voided_encounter"

  create_table "encounter_type", :primary_key => "encounter_type_id", :force => true do |t|
    t.string   "name",          :limit => 50, :default => "",    :null => false
    t.string   "description",   :limit => 50, :default => "",    :null => false
    t.integer  "creator",                     :default => 0,     :null => false
    t.datetime "date_created",                                   :null => false
    t.boolean  "retired",                     :default => false, :null => false
    t.integer  "retired_by"
    t.datetime "date_retired"
    t.string   "retire_reason"
  end

  add_index "encounter_type", ["creator"], :name => "user_who_created_type"
  add_index "encounter_type", ["retired"], :name => "retired_status"
  add_index "encounter_type", ["retired_by"], :name => "user_who_retired_encounter_type"

  create_table "field", :primary_key => "field_id", :force => true do |t|
    t.string   "name",                          :default => "",    :null => false
    t.text     "description"
    t.integer  "field_type"
    t.integer  "concept_id"
    t.string   "table_name",      :limit => 50
    t.string   "attribute_name",  :limit => 50
    t.text     "default_value"
    t.boolean  "select_multiple",               :default => false, :null => false
    t.integer  "creator",                       :default => 0,     :null => false
    t.datetime "date_created",                                     :null => false
    t.integer  "changed_by"
    t.datetime "date_changed"
    t.boolean  "retired",                       :default => false, :null => false
    t.integer  "retired_by"
    t.datetime "date_retired"
    t.string   "retire_reason"
  end

  add_index "field", ["changed_by"], :name => "user_who_changed_field"
  add_index "field", ["concept_id"], :name => "concept_for_field"
  add_index "field", ["creator"], :name => "user_who_created_field"
  add_index "field", ["field_type"], :name => "type_of_field"
  add_index "field", ["retired"], :name => "field_retired_status"
  add_index "field", ["retired_by"], :name => "user_who_retired_field"

  create_table "field_answer", :id => false, :force => true do |t|
    t.integer  "field_id",     :default => 0, :null => false
    t.integer  "answer_id",    :default => 0, :null => false
    t.integer  "creator",      :default => 0, :null => false
    t.datetime "date_created",                :null => false
  end

  add_index "field_answer", ["answer_id"], :name => "field_answer_concept"
  add_index "field_answer", ["creator"], :name => "user_who_created_field_answer"
  add_index "field_answer", ["field_id"], :name => "answers_for_field"

  create_table "field_type", :primary_key => "field_type_id", :force => true do |t|
    t.string   "name",         :limit => 50
    t.text     "description",  :limit => 2147483647
    t.boolean  "is_set",                             :default => false, :null => false
    t.integer  "creator",                            :default => 0,     :null => false
    t.datetime "date_created",                                          :null => false
  end

  add_index "field_type", ["creator"], :name => "user_who_created_field_type"

  create_table "form", :primary_key => "form_id", :force => true do |t|
    t.string   "name",                               :default => "",    :null => false
    t.string   "version",        :limit => 50,       :default => "",    :null => false
    t.integer  "build"
    t.integer  "published",      :limit => 1,        :default => 0,     :null => false
    t.text     "description"
    t.integer  "encounter_type"
    t.text     "template",       :limit => 16777215
    t.text     "xslt",           :limit => 16777215
    t.integer  "creator",                            :default => 0,     :null => false
    t.datetime "date_created",                                          :null => false
    t.integer  "changed_by"
    t.datetime "date_changed"
    t.boolean  "retired",                            :default => false, :null => false
    t.integer  "retired_by"
    t.datetime "date_retired"
    t.string   "retired_reason"
  end

  add_index "form", ["changed_by"], :name => "user_who_last_changed_form"
  add_index "form", ["creator"], :name => "user_who_created_form"
  add_index "form", ["encounter_type"], :name => "encounter_type"
  add_index "form", ["retired_by"], :name => "user_who_retired_form"

  create_table "form_field", :primary_key => "form_field_id", :force => true do |t|
    t.integer  "form_id",                         :default => 0, :null => false
    t.integer  "field_id",                        :default => 0, :null => false
    t.integer  "field_number"
    t.string   "field_part",        :limit => 5
    t.integer  "page_number"
    t.integer  "parent_form_field"
    t.integer  "min_occurs"
    t.integer  "max_occurs"
    t.boolean  "required"
    t.integer  "changed_by"
    t.datetime "date_changed"
    t.integer  "creator",                         :default => 0, :null => false
    t.datetime "date_created",                                   :null => false
    t.float    "sort_weight",       :limit => 11
  end

  add_index "form_field", ["changed_by"], :name => "user_who_last_changed_form_field"
  add_index "form_field", ["creator"], :name => "user_who_created_form_field"
  add_index "form_field", ["field_id"], :name => "field_within_form"
  add_index "form_field", ["form_id"], :name => "form_containing_field"
  add_index "form_field", ["parent_form_field"], :name => "form_field_hierarchy"

  create_table "formentry_archive", :primary_key => "formentry_archive_id", :force => true do |t|
    t.text     "form_data",    :limit => 16777215,                :null => false
    t.datetime "date_created",                                    :null => false
    t.integer  "creator",                          :default => 0, :null => false
  end

  add_index "formentry_archive", ["creator"], :name => "User who created formentry_archive"

  create_table "formentry_error", :primary_key => "formentry_error_id", :force => true do |t|
    t.text     "form_data",     :limit => 16777215,                 :null => false
    t.string   "error",                             :default => "", :null => false
    t.text     "error_details"
    t.integer  "creator",                           :default => 0,  :null => false
    t.datetime "date_created",                                      :null => false
  end

  add_index "formentry_error", ["creator"], :name => "User who created formentry_error"

  create_table "formentry_queue", :primary_key => "formentry_queue_id", :force => true do |t|
    t.text     "form_data",    :limit => 16777215,                :null => false
    t.integer  "creator",                          :default => 0, :null => false
    t.datetime "date_created",                                    :null => false
  end

  create_table "global_property", :primary_key => "property", :force => true do |t|
    t.text "property_value", :limit => 16777215
    t.text "description"
  end

  create_table "hl7_in_archive", :primary_key => "hl7_in_archive_id", :force => true do |t|
    t.integer  "hl7_source",                         :default => 0, :null => false
    t.string   "hl7_source_key"
    t.text     "hl7_data",       :limit => 16777215,                :null => false
    t.datetime "date_created",                                      :null => false
  end

  create_table "hl7_in_error", :primary_key => "hl7_in_error_id", :force => true do |t|
    t.integer  "hl7_source",                         :default => 0,  :null => false
    t.text     "hl7_source_key"
    t.text     "hl7_data",       :limit => 16777215,                 :null => false
    t.string   "error",                              :default => "", :null => false
    t.text     "error_details"
    t.datetime "date_created",                                       :null => false
  end

  create_table "hl7_in_queue", :primary_key => "hl7_in_queue_id", :force => true do |t|
    t.integer  "hl7_source",                         :default => 0, :null => false
    t.text     "hl7_source_key"
    t.text     "hl7_data",       :limit => 16777215,                :null => false
    t.integer  "state",                              :default => 0, :null => false
    t.datetime "date_processed"
    t.text     "error_msg"
    t.datetime "date_created"
  end

  add_index "hl7_in_queue", ["hl7_source"], :name => "hl7_source"

  create_table "hl7_source", :primary_key => "hl7_source_id", :force => true do |t|
    t.string   "name",                        :default => "", :null => false
    t.text     "description",  :limit => 255
    t.integer  "creator",                     :default => 0,  :null => false
    t.datetime "date_created",                                :null => false
  end

  add_index "hl7_source", ["creator"], :name => "creator"

  create_table "location", :primary_key => "location_id", :force => true do |t|
    t.string   "name",                            :default => "",    :null => false
    t.string   "description"
    t.string   "address1",          :limit => 50
    t.string   "address2",          :limit => 50
    t.string   "city_village",      :limit => 50
    t.string   "state_province",    :limit => 50
    t.string   "postal_code",       :limit => 50
    t.string   "country",           :limit => 50
    t.string   "latitude",          :limit => 50
    t.string   "longitude",         :limit => 50
    t.integer  "creator",                         :default => 0,     :null => false
    t.datetime "date_created",                                       :null => false
    t.string   "county_district",   :limit => 50
    t.string   "neighborhood_cell", :limit => 50
    t.string   "region",            :limit => 50
    t.string   "subregion",         :limit => 50
    t.string   "township_division", :limit => 50
    t.boolean  "retired",                         :default => false, :null => false
    t.integer  "retired_by"
    t.datetime "date_retired"
    t.string   "retire_reason"
  end

  add_index "location", ["creator"], :name => "user_who_created_location"
  add_index "location", ["name"], :name => "name_of_location"
  add_index "location", ["retired"], :name => "retired_status"
  add_index "location", ["retired_by"], :name => "user_who_retired_location"

  create_table "mime_type", :primary_key => "mime_type_id", :force => true do |t|
    t.string "mime_type",   :limit => 75, :default => "", :null => false
    t.text   "description"
  end

  add_index "mime_type", ["mime_type_id"], :name => "mime_type_id"

  create_table "note", :primary_key => "note_id", :force => true do |t|
    t.string   "note_type",    :limit => 50
    t.integer  "patient_id"
    t.integer  "obs_id"
    t.integer  "encounter_id"
    t.text     "text",                                      :null => false
    t.integer  "priority"
    t.integer  "parent"
    t.integer  "creator",                    :default => 0, :null => false
    t.datetime "date_created",                              :null => false
    t.integer  "changed_by"
    t.datetime "date_changed"
  end

  add_index "note", ["changed_by"], :name => "user_who_changed_note"
  add_index "note", ["creator"], :name => "user_who_created_note"
  add_index "note", ["encounter_id"], :name => "encounter_note"
  add_index "note", ["obs_id"], :name => "obs_note"
  add_index "note", ["parent"], :name => "note_hierarchy"
  add_index "note", ["patient_id"], :name => "patient_note"

  create_table "notification_alert", :primary_key => "alert_id", :force => true do |t|
    t.integer  "user_id"
    t.string   "text",             :limit => 512,                :null => false
    t.integer  "satisfied_by_any",                :default => 0, :null => false
    t.integer  "alert_read",                      :default => 0, :null => false
    t.datetime "date_to_expire"
    t.integer  "creator",                                        :null => false
    t.datetime "date_created",                                   :null => false
    t.integer  "changed_by"
    t.datetime "date_changed"
  end

  add_index "notification_alert", ["changed_by"], :name => "user_who_changed_alert"
  add_index "notification_alert", ["creator"], :name => "alert_creator"
  add_index "notification_alert", ["user_id"], :name => "alert_assigned_to_user"

  create_table "notification_alert_recipient", :id => false, :force => true do |t|
    t.integer   "alert_id",                    :null => false
    t.integer   "user_id",                     :null => false
    t.integer   "alert_read",   :default => 0, :null => false
    t.timestamp "date_changed"
  end

  add_index "notification_alert_recipient", ["alert_id"], :name => "id_of_alert"
  add_index "notification_alert_recipient", ["user_id"], :name => "alert_read_by_user"

  create_table "notification_template", :primary_key => "template_id", :force => true do |t|
    t.string  "name",       :limit => 50
    t.text    "template"
    t.string  "subject",    :limit => 100
    t.string  "sender"
    t.string  "recipients", :limit => 512
    t.integer "ordinal",                   :default => 0
  end

  create_table "obs", :primary_key => "obs_id", :force => true do |t|
    t.integer  "person_id",                                        :null => false
    t.integer  "concept_id",                    :default => 0,     :null => false
    t.integer  "encounter_id"
    t.integer  "order_id"
    t.datetime "obs_datetime",                                     :null => false
    t.integer  "location_id",                   :default => 0,     :null => false
    t.integer  "obs_group_id"
    t.string   "accession_number"
    t.integer  "value_group_id"
    t.boolean  "value_boolean"
    t.integer  "value_coded"
    t.integer  "value_drug"
    t.datetime "value_datetime"
    t.float    "value_numeric"
    t.string   "value_modifier",   :limit => 2
    t.text     "value_text"
    t.datetime "date_started"
    t.datetime "date_stopped"
    t.string   "comments"
    t.integer  "creator",                       :default => 0,     :null => false
    t.datetime "date_created",                                     :null => false
    t.boolean  "voided",                        :default => false, :null => false
    t.integer  "voided_by"
    t.datetime "date_voided"
    t.string   "void_reason"
  end

  add_index "obs", ["concept_id"], :name => "obs_concept"
  add_index "obs", ["creator"], :name => "obs_enterer"
  add_index "obs", ["encounter_id"], :name => "encounter_observations"
  add_index "obs", ["location_id"], :name => "obs_location"
  add_index "obs", ["obs_group_id"], :name => "obs_grouping_id"
  add_index "obs", ["order_id"], :name => "obs_order"
  add_index "obs", ["person_id"], :name => "patient_obs"
  add_index "obs", ["value_coded"], :name => "answer_concept"
  add_index "obs", ["value_drug"], :name => "answer_concept_drug"
  add_index "obs", ["voided_by"], :name => "user_who_voided_obs"

  create_table "order_type", :primary_key => "order_type_id", :force => true do |t|
    t.string   "name",          :default => "",    :null => false
    t.string   "description",   :default => "",    :null => false
    t.integer  "creator",       :default => 0,     :null => false
    t.datetime "date_created",                     :null => false
    t.boolean  "retired",       :default => false, :null => false
    t.integer  "retired_by"
    t.datetime "date_retired"
    t.string   "retire_reason"
  end

  add_index "order_type", ["creator"], :name => "type_created_by"
  add_index "order_type", ["retired"], :name => "retired_status"
  add_index "order_type", ["retired_by"], :name => "user_who_retired_order_type"

  create_table "orders", :primary_key => "order_id", :force => true do |t|
    t.integer  "order_type_id",       :default => 0,     :null => false
    t.integer  "concept_id",          :default => 0,     :null => false
    t.integer  "orderer",             :default => 0
    t.integer  "encounter_id"
    t.text     "instructions"
    t.datetime "start_date"
    t.datetime "auto_expire_date"
    t.boolean  "discontinued",        :default => false, :null => false
    t.datetime "discontinued_date"
    t.integer  "discontinued_by"
    t.integer  "discontinued_reason"
    t.integer  "creator",             :default => 0,     :null => false
    t.datetime "date_created",                           :null => false
    t.boolean  "voided",              :default => false, :null => false
    t.integer  "voided_by"
    t.datetime "date_voided"
    t.string   "void_reason"
    t.integer  "patient_id",                             :null => false
  end

  add_index "orders", ["creator"], :name => "order_creator"
  add_index "orders", ["discontinued_by"], :name => "user_who_discontinued_order"
  add_index "orders", ["discontinued_reason"], :name => "discontinued_because"
  add_index "orders", ["encounter_id"], :name => "orders_in_encounter"
  add_index "orders", ["order_type_id"], :name => "type_of_order"
  add_index "orders", ["orderer"], :name => "orderer_not_drug"
  add_index "orders", ["patient_id"], :name => "order_for_patient"
  add_index "orders", ["voided_by"], :name => "user_who_voided_order"

  create_table "patient", :primary_key => "patient_id", :force => true do |t|
    t.integer  "tribe"
    t.integer  "creator",      :default => 0,     :null => false
    t.datetime "date_created",                    :null => false
    t.integer  "changed_by"
    t.datetime "date_changed"
    t.boolean  "voided",       :default => false, :null => false
    t.integer  "voided_by"
    t.datetime "date_voided"
    t.string   "void_reason"
  end

  add_index "patient", ["changed_by"], :name => "user_who_changed_pat"
  add_index "patient", ["creator"], :name => "user_who_created_patient"
  add_index "patient", ["tribe"], :name => "belongs_to_tribe"
  add_index "patient", ["voided_by"], :name => "user_who_voided_patient"

  create_table "patient_identifier", :id => false, :force => true do |t|
    t.integer  "patient_id",                    :default => 0,     :null => false
    t.string   "identifier",      :limit => 50, :default => "",    :null => false
    t.integer  "identifier_type",               :default => 0,     :null => false
    t.integer  "preferred",       :limit => 1,  :default => 0,     :null => false
    t.integer  "location_id",                   :default => 0,     :null => false
    t.integer  "creator",                       :default => 0,     :null => false
    t.datetime "date_created",                                     :null => false
    t.boolean  "voided",                        :default => false, :null => false
    t.integer  "voided_by"
    t.datetime "date_voided"
    t.string   "void_reason"
  end

  add_index "patient_identifier", ["creator"], :name => "identifier_creator"
  add_index "patient_identifier", ["identifier"], :name => "identifier_name"
  add_index "patient_identifier", ["identifier_type"], :name => "defines_identifier_type"
  add_index "patient_identifier", ["location_id"], :name => "identifier_location"
  add_index "patient_identifier", ["voided_by"], :name => "identifier_voider"

  create_table "patient_identifier_type", :primary_key => "patient_identifier_type_id", :force => true do |t|
    t.string   "name",               :limit => 50,  :default => "",    :null => false
    t.text     "description",                                          :null => false
    t.string   "format",             :limit => 50
    t.boolean  "check_digit",                       :default => false, :null => false
    t.integer  "creator",                           :default => 0,     :null => false
    t.datetime "date_created",                                         :null => false
    t.boolean  "required",                          :default => false, :null => false
    t.string   "format_description"
    t.string   "validator",          :limit => 200
    t.boolean  "retired",                           :default => false, :null => false
    t.integer  "retired_by"
    t.datetime "date_retired"
    t.string   "retire_reason"
  end

  add_index "patient_identifier_type", ["creator"], :name => "type_creator"
  add_index "patient_identifier_type", ["retired"], :name => "retired_status"
  add_index "patient_identifier_type", ["retired_by"], :name => "user_who_retired_patient_identifier_type"

  create_table "patient_program", :primary_key => "patient_program_id", :force => true do |t|
    t.integer  "patient_id",     :default => 0,     :null => false
    t.integer  "program_id",     :default => 0,     :null => false
    t.datetime "date_enrolled"
    t.datetime "date_completed"
    t.integer  "creator",        :default => 0,     :null => false
    t.datetime "date_created",                      :null => false
    t.integer  "changed_by"
    t.datetime "date_changed"
    t.boolean  "voided",         :default => false, :null => false
    t.integer  "voided_by"
    t.datetime "date_voided"
    t.string   "void_reason"
  end

  add_index "patient_program", ["changed_by"], :name => "user_who_changed"
  add_index "patient_program", ["creator"], :name => "patient_program_creator"
  add_index "patient_program", ["patient_id"], :name => "patient_in_program"
  add_index "patient_program", ["program_id"], :name => "program_for_patient"
  add_index "patient_program", ["voided_by"], :name => "user_who_voided_patient_program"

  create_table "patient_state", :primary_key => "patient_state_id", :force => true do |t|
    t.integer  "patient_program_id", :default => 0,     :null => false
    t.integer  "state",              :default => 0,     :null => false
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "creator",            :default => 0,     :null => false
    t.datetime "date_created",                          :null => false
    t.integer  "changed_by"
    t.datetime "date_changed"
    t.boolean  "voided",             :default => false, :null => false
    t.integer  "voided_by"
    t.datetime "date_voided"
    t.string   "void_reason"
  end

  add_index "patient_state", ["changed_by"], :name => "patient_state_changer"
  add_index "patient_state", ["creator"], :name => "patient_state_creator"
  add_index "patient_state", ["patient_program_id"], :name => "patient_program_for_state"
  add_index "patient_state", ["state"], :name => "state_for_patient"
  add_index "patient_state", ["voided_by"], :name => "patient_state_voider"

  create_table "person", :primary_key => "person_id", :force => true do |t|
    t.string   "gender",              :limit => 50, :default => ""
    t.date     "birthdate"
    t.boolean  "birthdate_estimated"
    t.boolean  "dead",                              :default => false, :null => false
    t.datetime "death_date"
    t.integer  "cause_of_death"
    t.integer  "creator",                           :default => 0,     :null => false
    t.datetime "date_created",                                         :null => false
    t.integer  "changed_by"
    t.datetime "date_changed"
    t.boolean  "voided",                            :default => false, :null => false
    t.integer  "voided_by"
    t.datetime "date_voided"
    t.string   "void_reason"
  end

  add_index "person", ["birthdate"], :name => "person_birthdate"
  add_index "person", ["cause_of_death"], :name => "person_died_because"
  add_index "person", ["changed_by"], :name => "user_who_changed_pat"
  add_index "person", ["creator"], :name => "user_who_created_patient"
  add_index "person", ["death_date"], :name => "person_death_date"
  add_index "person", ["voided_by"], :name => "user_who_voided_patient"

  create_table "person_address", :primary_key => "person_address_id", :force => true do |t|
    t.integer  "person_id"
    t.boolean  "preferred",                       :default => false, :null => false
    t.string   "address1",          :limit => 50
    t.string   "address2",          :limit => 50
    t.string   "city_village",      :limit => 50
    t.string   "state_province",    :limit => 50
    t.string   "postal_code",       :limit => 50
    t.string   "country",           :limit => 50
    t.string   "latitude",          :limit => 50
    t.string   "longitude",         :limit => 50
    t.integer  "creator",                         :default => 0,     :null => false
    t.datetime "date_created",                                       :null => false
    t.boolean  "voided",                          :default => false, :null => false
    t.integer  "voided_by"
    t.datetime "date_voided"
    t.string   "void_reason"
    t.string   "county_district",   :limit => 50
    t.string   "neighborhood_cell", :limit => 50
    t.string   "region",            :limit => 50
    t.string   "subregion",         :limit => 50
    t.string   "township_division", :limit => 50
  end

  add_index "person_address", ["creator"], :name => "patient_address_creator"
  add_index "person_address", ["person_id"], :name => "patient_addresses"
  add_index "person_address", ["voided_by"], :name => "patient_address_void"

  create_table "person_attribute", :primary_key => "person_attribute_id", :force => true do |t|
    t.integer  "person_id",                              :default => 0,     :null => false
    t.string   "value",                    :limit => 50, :default => "",    :null => false
    t.integer  "person_attribute_type_id",               :default => 0,     :null => false
    t.integer  "creator",                                :default => 0,     :null => false
    t.datetime "date_created",                                              :null => false
    t.integer  "changed_by"
    t.datetime "date_changed"
    t.boolean  "voided",                                 :default => false, :null => false
    t.integer  "voided_by"
    t.datetime "date_voided"
    t.string   "void_reason"
  end

  add_index "person_attribute", ["changed_by"], :name => "attribute_changer"
  add_index "person_attribute", ["creator"], :name => "attribute_creator"
  add_index "person_attribute", ["person_attribute_type_id"], :name => "defines_attribute_type"
  add_index "person_attribute", ["person_id"], :name => "identifies_person"
  add_index "person_attribute", ["voided_by"], :name => "attribute_voider"

  create_table "person_attribute_type", :primary_key => "person_attribute_type_id", :force => true do |t|
    t.string   "name",          :limit => 50, :default => "",    :null => false
    t.text     "description",                                    :null => false
    t.string   "format",        :limit => 50
    t.integer  "foreign_key"
    t.boolean  "searchable",                  :default => false, :null => false
    t.integer  "creator",                     :default => 0,     :null => false
    t.datetime "date_created",                                   :null => false
    t.integer  "changed_by"
    t.datetime "date_changed"
    t.boolean  "retired",                     :default => false, :null => false
    t.integer  "retired_by"
    t.datetime "date_retired"
    t.string   "retire_reason"
  end

  add_index "person_attribute_type", ["changed_by"], :name => "attribute_type_changer"
  add_index "person_attribute_type", ["creator"], :name => "type_creator"
  add_index "person_attribute_type", ["name"], :name => "name_of_attribute"
  add_index "person_attribute_type", ["retired"], :name => "person_attribute_type_retired_status"
  add_index "person_attribute_type", ["retired_by"], :name => "user_who_retired_person_attribute_type"
  add_index "person_attribute_type", ["searchable"], :name => "attribute_is_searchable"

  create_table "person_name", :primary_key => "person_name_id", :force => true do |t|
    t.boolean  "preferred",                        :default => false, :null => false
    t.integer  "person_id"
    t.string   "prefix",             :limit => 50
    t.string   "given_name",         :limit => 50
    t.string   "middle_name",        :limit => 50
    t.string   "family_name_prefix", :limit => 50
    t.string   "family_name",        :limit => 50
    t.string   "family_name2",       :limit => 50
    t.string   "family_name_suffix", :limit => 50
    t.string   "degree",             :limit => 50
    t.integer  "creator",                          :default => 0,     :null => false
    t.datetime "date_created",                                        :null => false
    t.boolean  "voided",                           :default => false, :null => false
    t.integer  "voided_by"
    t.datetime "date_voided"
    t.string   "void_reason"
    t.integer  "changed_by"
    t.datetime "date_changed"
  end

  add_index "person_name", ["creator"], :name => "user_who_made_name"
  add_index "person_name", ["family_name"], :name => "last_name"
  add_index "person_name", ["given_name"], :name => "first_name"
  add_index "person_name", ["middle_name"], :name => "middle_name"
  add_index "person_name", ["person_id"], :name => "name_for_patient"
  add_index "person_name", ["voided_by"], :name => "user_who_voided_name"

  create_table "privilege", :primary_key => "privilege", :force => true do |t|
    t.string "description", :limit => 250, :default => "", :null => false
  end

  create_table "program", :primary_key => "program_id", :force => true do |t|
    t.integer  "concept_id",                  :default => 0,     :null => false
    t.integer  "creator",                     :default => 0,     :null => false
    t.datetime "date_created",                                   :null => false
    t.integer  "changed_by"
    t.datetime "date_changed"
    t.boolean  "retired",                     :default => false, :null => false
    t.string   "name",         :limit => 50,                     :null => false
    t.string   "description",  :limit => 500
  end

  add_index "program", ["changed_by"], :name => "user_who_changed_program"
  add_index "program", ["concept_id"], :name => "program_concept"
  add_index "program", ["creator"], :name => "program_creator"

  create_table "program_workflow", :primary_key => "program_workflow_id", :force => true do |t|
    t.integer  "program_id",   :default => 0,     :null => false
    t.integer  "concept_id",   :default => 0,     :null => false
    t.integer  "creator",      :default => 0,     :null => false
    t.datetime "date_created",                    :null => false
    t.boolean  "retired",      :default => false, :null => false
    t.integer  "changed_by"
    t.datetime "date_changed"
  end

  add_index "program_workflow", ["changed_by"], :name => "workflow_voided_by"
  add_index "program_workflow", ["concept_id"], :name => "workflow_concept"
  add_index "program_workflow", ["creator"], :name => "workflow_creator"
  add_index "program_workflow", ["program_id"], :name => "program_for_workflow"

  create_table "program_workflow_state", :primary_key => "program_workflow_state_id", :force => true do |t|
    t.integer  "program_workflow_id", :default => 0,     :null => false
    t.integer  "concept_id",          :default => 0,     :null => false
    t.boolean  "initial",             :default => false, :null => false
    t.boolean  "terminal",            :default => false, :null => false
    t.integer  "creator",             :default => 0,     :null => false
    t.datetime "date_created",                           :null => false
    t.boolean  "retired",             :default => false, :null => false
    t.integer  "changed_by"
    t.datetime "date_changed"
  end

  add_index "program_workflow_state", ["changed_by"], :name => "state_voided_by"
  add_index "program_workflow_state", ["concept_id"], :name => "state_concept"
  add_index "program_workflow_state", ["creator"], :name => "state_creator"
  add_index "program_workflow_state", ["program_workflow_id"], :name => "workflow_for_state"

  create_table "relationship", :primary_key => "relationship_id", :force => true do |t|
    t.integer  "person_a",                        :null => false
    t.integer  "relationship", :default => 0,     :null => false
    t.integer  "person_b",                        :null => false
    t.integer  "creator",      :default => 0,     :null => false
    t.datetime "date_created",                    :null => false
    t.boolean  "voided",       :default => false, :null => false
    t.integer  "voided_by"
    t.datetime "date_voided"
    t.string   "void_reason"
  end

  add_index "relationship", ["creator"], :name => "relation_creator"
  add_index "relationship", ["person_a"], :name => "related_person"
  add_index "relationship", ["person_b"], :name => "related_relative"
  add_index "relationship", ["relationship"], :name => "relationship_type"
  add_index "relationship", ["voided_by"], :name => "relation_voider"

  create_table "relationship_type", :primary_key => "relationship_type_id", :force => true do |t|
    t.string   "a_is_to_b",    :limit => 50,                 :null => false
    t.string   "b_is_to_a",    :limit => 50,                 :null => false
    t.integer  "preferred",                  :default => 0,  :null => false
    t.integer  "weight",                     :default => 0,  :null => false
    t.string   "description",                :default => "", :null => false
    t.integer  "creator",                    :default => 0,  :null => false
    t.datetime "date_created",                               :null => false
  end

  add_index "relationship_type", ["creator"], :name => "user_who_created_rel"

  create_table "report_object", :primary_key => "report_object_id", :force => true do |t|
    t.string   "name",                                   :null => false
    t.string   "description",            :limit => 1000
    t.string   "report_object_type",                     :null => false
    t.string   "report_object_sub_type",                 :null => false
    t.text     "xml_data"
    t.integer  "creator",                                :null => false
    t.datetime "date_created",                           :null => false
    t.integer  "changed_by"
    t.datetime "date_changed"
    t.boolean  "voided",                                 :null => false
    t.integer  "voided_by"
    t.datetime "date_voided"
    t.string   "void_reason"
  end

  add_index "report_object", ["changed_by"], :name => "user_who_changed_report_object"
  add_index "report_object", ["creator"], :name => "report_object_creator"
  add_index "report_object", ["voided_by"], :name => "user_who_voided_report_object"

  create_table "report_schema_xml", :primary_key => "report_schema_id", :force => true do |t|
    t.string "name",                            :null => false
    t.text   "description",                     :null => false
    t.text   "xml_data",    :limit => 16777215, :null => false
  end

  create_table "role", :primary_key => "role", :force => true do |t|
    t.string "description", :default => "", :null => false
  end

  create_table "role_privilege", :id => false, :force => true do |t|
    t.string "role",      :limit => 50, :default => "", :null => false
    t.string "privilege", :limit => 50, :default => "", :null => false
  end

  add_index "role_privilege", ["role"], :name => "role_privilege"

  create_table "role_role", :id => false, :force => true do |t|
    t.string "parent_role", :limit => 50, :default => "", :null => false
    t.string "child_role",                :default => "", :null => false
  end

  add_index "role_role", ["child_role"], :name => "inherited_role"

  create_table "scheduler_task_config", :primary_key => "task_config_id", :force => true do |t|
    t.string   "name",                                                                  :null => false
    t.string   "description",        :limit => 1024
    t.text     "schedulable_class"
    t.datetime "start_time"
    t.string   "start_time_pattern", :limit => 50
    t.integer  "repeat_interval",                    :default => 0,                     :null => false
    t.integer  "start_on_startup",                   :default => 0,                     :null => false
    t.integer  "started",                            :default => 0,                     :null => false
    t.integer  "created_by",                         :default => 0
    t.datetime "date_created",                       :default => '2005-01-01 00:00:00'
    t.integer  "changed_by"
    t.datetime "date_changed"
  end

  add_index "scheduler_task_config", ["changed_by"], :name => "schedule_changer"
  add_index "scheduler_task_config", ["created_by"], :name => "schedule_creator"

  create_table "scheduler_task_config_property", :primary_key => "task_config_property_id", :force => true do |t|
    t.string  "name",           :null => false
    t.text    "value"
    t.integer "task_config_id"
  end

  add_index "scheduler_task_config_property", ["task_config_id"], :name => "task_config"

  create_table "tribe", :primary_key => "tribe_id", :force => true do |t|
    t.boolean "retired",               :default => false, :null => false
    t.string  "name",    :limit => 50, :default => "",    :null => false
  end

  create_table "user_property", :id => false, :force => true do |t|
    t.integer "user_id",                       :default => 0,  :null => false
    t.string  "property",       :limit => 100, :default => "", :null => false
    t.string  "property_value",                :default => "", :null => false
  end

  create_table "user_role", :id => false, :force => true do |t|
    t.integer "user_id",               :default => 0,  :null => false
    t.string  "role",    :limit => 50, :default => "", :null => false
  end

  add_index "user_role", ["user_id"], :name => "user_role"

  create_table "users", :primary_key => "user_id", :force => true do |t|
    t.string   "system_id",       :limit => 50, :default => "",    :null => false
    t.string   "username",        :limit => 50
    t.string   "password",        :limit => 50
    t.string   "salt",            :limit => 50
    t.string   "secret_question"
    t.string   "secret_answer"
    t.integer  "creator",                       :default => 0,     :null => false
    t.datetime "date_created",                                     :null => false
    t.integer  "changed_by"
    t.datetime "date_changed"
    t.boolean  "voided",                        :default => false, :null => false
    t.integer  "voided_by"
    t.datetime "date_voided"
    t.string   "void_reason"
  end

  add_index "users", ["changed_by"], :name => "user_who_changed_user"
  add_index "users", ["creator"], :name => "user_creator"
  add_index "users", ["voided_by"], :name => "user_who_voided_user"

end
