# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180618135251) do

  create_table "account_charge_items", force: :cascade do |t|
    t.integer  "fee_amount_pennies",     limit: 4,     default: 0,     null: false
    t.string   "fee_amount_currency",    limit: 255,   default: "GBP", null: false
    t.integer  "outlay_amount_pennies",  limit: 4,     default: 0,     null: false
    t.string   "outlay_amount_currency", limit: 255,   default: "GBP", null: false
    t.text     "narrative",              limit: 65535
    t.integer  "account_id",             limit: 4
    t.integer  "chargeable_item_id",     limit: 4
    t.string   "chargeable_item_type",   limit: 255
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.integer  "item_charge_rate_id",    limit: 4
    t.datetime "item_date"
  end

  add_index "account_charge_items", ["account_id"], name: "account_charge_item_index", using: :btree
  add_index "account_charge_items", ["chargeable_item_type", "chargeable_item_id"], name: "chargeable_charge_index", using: :btree
  add_index "account_charge_items", ["item_charge_rate_id"], name: "index_account_charge_items_on_item_charge_rate_id", using: :btree

  create_table "account_charge_rates", force: :cascade do |t|
    t.integer  "fixed_fee_pennies",  limit: 4,   default: 0,     null: false
    t.string   "fixed_fee_currency", limit: 255, default: "GBP", null: false
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  create_table "account_increases", force: :cascade do |t|
    t.integer  "amount_pennies",  limit: 4,   default: 0,     null: false
    t.string   "amount_currency", limit: 255, default: "GBP", null: false
    t.date     "date_granted"
    t.string   "granted_by",      limit: 255
    t.integer  "account_id",      limit: 4
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "account_increases", ["account_id"], name: "index_account_increases_on_account_id", using: :btree

  create_table "account_types", force: :cascade do |t|
    t.string   "name",                               limit: 255
    t.integer  "initial_expenditure_limit_pennies",  limit: 4,   default: 0,             null: false
    t.string   "initial_expenditure_limit_currency", limit: 255, default: "GBP",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_private",                                     default: false
    t.integer  "account_charge_rate_id",             limit: 4
    t.string   "account_charge_type",                limit: 255, default: "TimeAndLine"
  end

  add_index "account_types", ["account_charge_rate_id"], name: "index_account_types_on_account_charge_rate_id", using: :btree
  add_index "account_types", ["name"], name: "index_account_types_on_name", unique: true, using: :btree

  create_table "accounts", force: :cascade do |t|
    t.date     "effective_from"
    t.date     "effective_until"
    t.date     "feed_upto"
    t.date     "feed_date"
    t.string   "reference",                  limit: 255
    t.string   "feed_status",                limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "expenditure_limit_pennies",  limit: 4,   default: 0,     null: false
    t.string   "expenditure_limit_currency", limit: 255, default: "GBP", null: false
    t.integer  "expenditure_pennies",        limit: 4,   default: 0,     null: false
    t.string   "expenditure_currency",       limit: 255, default: "GBP", null: false
    t.integer  "client_file_id",             limit: 4
    t.integer  "account_type_id",            limit: 4
    t.integer  "nominated_solicitor_id",     limit: 4
    t.integer  "auxiliary_id",               limit: 4
    t.datetime "last_charged_on"
  end

  add_index "accounts", ["auxiliary_id"], name: "index_accounts_on_auxiliary_id", unique: true, using: :btree
  add_index "accounts", ["client_file_id"], name: "index_accounts_on_client_file_id", using: :btree

  create_table "attendance_appearings", force: :cascade do |t|
    t.boolean  "counsel"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "attendance_waitings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "charge_items", force: :cascade do |t|
    t.integer  "fee_amount_pennies",      limit: 4,   default: 0,     null: false
    t.string   "fee_amount_currency",     limit: 255, default: "GBP", null: false
    t.integer  "outlay_amount_pennies",   limit: 4,   default: 0,     null: false
    t.string   "outlay_amount_currency",  limit: 255, default: "GBP", null: false
    t.string   "narrative",               limit: 255
    t.integer  "account_id",              limit: 4
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.integer  "account_chargeable_id",   limit: 4
    t.string   "account_chargeable_type", limit: 255
  end

  add_index "charge_items", ["account_chargeable_type", "account_chargeable_id"], name: "account_chargeable_index", using: :btree
  add_index "charge_items", ["account_id"], name: "index_charge_items_on_account_id", using: :btree

  create_table "civilians", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.string   "name",       limit: 255
    t.text     "address",    limit: 65535
    t.string   "telephone",  limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "claims", force: :cascade do |t|
    t.date     "claim_date"
    t.integer  "amount_pennies",           limit: 4,   default: 0,     null: false
    t.string   "amount_currency",          limit: 255, default: "GBP", null: false
    t.boolean  "accepted",                             default: false
    t.boolean  "problem",                              default: false
    t.string   "notes",                    limit: 255
    t.integer  "account_id",               limit: 4
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.integer  "auxiliary_id",             limit: 4
    t.string   "slab_registration_number", limit: 255
    t.date     "last_payment_on"
  end

  add_index "claims", ["account_id"], name: "index_claims_on_account_id", using: :btree
  add_index "claims", ["auxiliary_id"], name: "index_claims_on_auxiliary_id", using: :btree
  add_index "claims", ["slab_registration_number"], name: "index_claims_on_slab_registration_number", using: :btree

  create_table "client_file_informations", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "client_file_informations", ["name"], name: "index_client_file_informations_on_name", unique: true, using: :btree

  create_table "client_file_types", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.string   "prefixes",      limit: 255
    t.string   "folder_colour", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "client_files", force: :cascade do |t|
    t.string   "file_number",                 limit: 255
    t.string   "subject_matter",              limit: 255
    t.string   "locus",                       limit: 255
    t.datetime "date_of_offence"
    t.datetime "date_open"
    t.datetime "date_closed"
    t.string   "disposal",                    limit: 255
    t.string   "procurator_fiscal_reference", limit: 255
    t.string   "police_reference",            limit: 255
    t.string   "disc_location",               limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",                     limit: 4
    t.integer  "client_id",                   limit: 4
    t.integer  "court_id",                    limit: 4
    t.integer  "procurator_fiscal_id",        limit: 4
    t.integer  "current_solicitor_id",        limit: 4
    t.integer  "partner_id",                  limit: 4
    t.integer  "client_file_information_id",  limit: 4
    t.integer  "auxiliary_id",                limit: 4
    t.integer  "file_status",                 limit: 4
    t.integer  "client_file_type_id",         limit: 4
    t.string   "alfresco_id",                 limit: 255
    t.string   "allocated",                   limit: 255
  end

  add_index "client_files", ["auxiliary_id"], name: "index_client_files_on_auxiliary_id", unique: true, using: :btree
  add_index "client_files", ["client_id"], name: "fk_rails_d4df103924", using: :btree
  add_index "client_files", ["file_number"], name: "index_client_files_on_file_number", unique: true, using: :btree

  create_table "clients", force: :cascade do |t|
    t.string   "type",                           limit: 255
    t.string   "company_name",                   limit: 255
    t.boolean  "local_agent",                                  default: false
    t.date     "birth_date"
    t.text     "address",                        limit: 65535
    t.string   "postcode",                       limit: 255
    t.string   "mobile_telephone",               limit: 255
    t.string   "home_telephone",                 limit: 255
    t.string   "contact_telephone",              limit: 255
    t.string   "legal_aid_id",                   limit: 255
    t.string   "prison_number",                  limit: 255
    t.integer  "auxiliary_id",                   limit: 4
    t.text     "additional_contact_information", limit: 65535
    t.integer  "personal_details_id",            limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",                        limit: 4
    t.integer  "location_id",                    limit: 4
    t.string   "national_insurance_number",      limit: 255
    t.string   "email_address",                  limit: 255
    t.string   "alfresco_id",                    limit: 255
  end

  add_index "clients", ["auxiliary_id"], name: "index_clients_on_auxiliary_id", using: :btree
  add_index "clients", ["personal_details_id"], name: "fk_rails_7107daf5d3", using: :btree

  create_table "court_attendances", force: :cascade do |t|
    t.integer  "court_date_id",       limit: 4
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "attendanceable_id",   limit: 4
    t.string   "attendanceable_type", limit: 255
  end

  add_index "court_attendances", ["attendanceable_type", "attendanceable_id"], name: "attendanceable_index", using: :btree
  add_index "court_attendances", ["court_date_id"], name: "index_court_attendances_on_court_date_id", using: :btree

  create_table "court_date_types", force: :cascade do |t|
    t.string   "name",                         limit: 255
    t.integer  "preparation_pennies",          limit: 4,   default: 0,     null: false
    t.string   "preparation_currency",         limit: 255, default: "GBP", null: false
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.integer  "following_court_date_type_id", limit: 4
  end

  add_index "court_date_types", ["following_court_date_type_id"], name: "index_court_date_types_on_following_court_date_type_id", using: :btree
  add_index "court_date_types", ["name"], name: "index_court_date_types_on_name", unique: true, using: :btree

  create_table "court_dates", force: :cascade do |t|
    t.datetime "court_date"
    t.integer  "client_file_id",     limit: 4
    t.integer  "court_id",           limit: 4
    t.integer  "court_date_type_id", limit: 4
    t.integer  "journey_id",         limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "user_id",            limit: 4
    t.integer  "auxiliary_id",       limit: 4
  end

  add_index "court_dates", ["auxiliary_id"], name: "index_court_dates_on_auxiliary_id", using: :btree
  add_index "court_dates", ["client_file_id"], name: "index_court_dates_on_client_file_id", using: :btree
  add_index "court_dates", ["court_date_type_id"], name: "index_court_dates_on_court_date_type_id", using: :btree
  add_index "court_dates", ["court_id"], name: "index_court_dates_on_court_id", using: :btree
  add_index "court_dates", ["journey_id"], name: "index_court_dates_on_journey_id", using: :btree
  add_index "court_dates", ["user_id"], name: "index_court_dates_on_user_id", using: :btree

  create_table "court_official_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "court_officials", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "court_official_type_id", limit: 4
  end

  create_table "court_types", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "recipient",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "court_official_id", limit: 4
  end

  create_table "courts", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.text     "address",             limit: 65535
    t.string   "city",                limit: 255
    t.string   "telephone",           limit: 255
    t.string   "fax",                 limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "court_type_id",       limit: 4
    t.integer  "police_authority_id", limit: 4
    t.integer  "jurisdiction_id",     limit: 4
  end

  add_index "courts", ["jurisdiction_id"], name: "index_courts_on_jurisdiction_id", using: :btree

  create_table "debit_entries", force: :cascade do |t|
    t.date     "debit_entry_date"
    t.text     "description",          limit: 65535
    t.integer  "vat_pennies",          limit: 4,     default: 0,     null: false
    t.string   "vat_currency",         limit: 255,   default: "GBP", null: false
    t.integer  "amount_pennies",       limit: 4,     default: 0,     null: false
    t.string   "amount_currency",      limit: 255,   default: "GBP", null: false
    t.integer  "client_file_id",       limit: 4
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.integer  "document_template_id", limit: 4
    t.integer  "total_pennies",        limit: 4,     default: 0,     null: false
    t.string   "total_currency",       limit: 255,   default: "GBP", null: false
    t.integer  "created_by_id",        limit: 4
    t.string   "payment_method",       limit: 255
  end

  add_index "debit_entries", ["client_file_id"], name: "index_debit_entries_on_client_file_id", using: :btree
  add_index "debit_entries", ["created_by_id"], name: "index_debit_entries_on_created_by_id", using: :btree
  add_index "debit_entries", ["document_template_id"], name: "index_debit_entries_on_document_template_id", using: :btree

  create_table "disclosures", force: :cascade do |t|
    t.integer  "client_file_id",            limit: 4
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "pdf_document_file_name",    limit: 255
    t.string   "pdf_document_content_type", limit: 255
    t.integer  "pdf_document_file_size",    limit: 4
    t.datetime "pdf_document_updated_at"
    t.string   "alfresco_id",               limit: 255
    t.boolean  "number_pages"
    t.string   "skip_pages",                limit: 255
    t.boolean  "skip_even"
    t.boolean  "skip_odd"
    t.integer  "first_page",                limit: 4
    t.integer  "last_page",                 limit: 4
  end

  add_index "disclosures", ["client_file_id"], name: "index_disclosures_on_client_file_id", using: :btree

  create_table "document_templates", force: :cascade do |t|
    t.string   "alfresco_id",                limit: 255
    t.string   "name",                       limit: 255
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "template_file_file_name",    limit: 255
    t.string   "template_file_content_type", limit: 255
    t.integer  "template_file_file_size",    limit: 4
    t.datetime "template_file_updated_at"
    t.string   "template_type",              limit: 255
    t.string   "category",                   limit: 255
  end

  add_index "document_templates", ["category"], name: "index_document_templates_on_category", using: :btree
  add_index "document_templates", ["template_type"], name: "index_document_templates_on_template_type", using: :btree

  create_table "documents", force: :cascade do |t|
    t.text     "description",                limit: 65535
    t.integer  "documentable_id",            limit: 4
    t.string   "documentable_type",          limit: 255
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "created_by_id",              limit: 4
    t.string   "document_file_file_name",    limit: 255
    t.string   "document_file_content_type", limit: 255
    t.integer  "document_file_file_size",    limit: 4
    t.datetime "document_file_updated_at"
    t.string   "alfresco_id",                limit: 255
  end

  add_index "documents", ["created_by_id"], name: "index_documents_on_created_by_id", using: :btree
  add_index "documents", ["documentable_type", "documentable_id"], name: "index_documents_on_documentable_type_and_documentable_id", using: :btree

  create_table "file_forms", force: :cascade do |t|
    t.datetime "form_date"
    t.text     "description",          limit: 65535
    t.boolean  "chargeable"
    t.integer  "created_by_id",        limit: 4
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "client_file_id",       limit: 4
    t.integer  "document_template_id", limit: 4
    t.integer  "witness_id",           limit: 4
    t.string   "cabinet_location",     limit: 255
    t.integer  "length",               limit: 4
  end

  add_index "file_forms", ["client_file_id"], name: "index_file_forms_on_client_file_id", using: :btree
  add_index "file_forms", ["created_by_id"], name: "index_file_forms_on_created_by_id", using: :btree
  add_index "file_forms", ["document_template_id"], name: "index_file_forms_on_document_template_id", using: :btree
  add_index "file_forms", ["witness_id"], name: "index_file_forms_on_witness_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups_permissions", id: false, force: :cascade do |t|
    t.integer "permission_id", limit: 4
    t.integer "group_id",      limit: 4
  end

  add_index "groups_permissions", ["group_id"], name: "index_groups_permissions_on_group_id", using: :btree
  add_index "groups_permissions", ["permission_id", "group_id"], name: "index_groups_permissions_on_permission_id_and_group_id", using: :btree

  create_table "groups_users", id: false, force: :cascade do |t|
    t.integer "group_id", limit: 4
    t.integer "user_id",  limit: 4
  end

  add_index "groups_users", ["group_id", "user_id"], name: "index_groups_users_on_group_id_and_user_id", using: :btree
  add_index "groups_users", ["user_id"], name: "index_groups_users_on_user_id", using: :btree

  create_table "item_charge_rates", force: :cascade do |t|
    t.string   "chargeable_item_name",              limit: 255
    t.string   "qualification_type",                limit: 255
    t.integer  "fixed_fee_pennies",                 limit: 4,   default: 0,     null: false
    t.string   "fixed_fee_currency",                limit: 255, default: "GBP", null: false
    t.integer  "initial_block_duration_mins",       limit: 4
    t.integer  "initial_block_charge_pennies",      limit: 4,   default: 0,     null: false
    t.string   "initial_block_charge_currency",     limit: 255, default: "GBP", null: false
    t.integer  "block_duration_mins",               limit: 4
    t.integer  "block_charge_pennies",              limit: 4,   default: 0,     null: false
    t.string   "block_charge_currency",             limit: 255, default: "GBP", null: false
    t.integer  "account_type_id",                   limit: 4
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
    t.integer  "block_distance_miles",              limit: 4
    t.integer  "block_distance_charge_pennies",     limit: 4,   default: 0,     null: false
    t.string   "block_distance_charge_currency",    limit: 255, default: "GBP", null: false
    t.integer  "block_word_length",                 limit: 4
    t.integer  "block_word_length_charge_pennies",  limit: 4,   default: 0,     null: false
    t.string   "block_word_length_charge_currency", limit: 255, default: "GBP", null: false
  end

  add_index "item_charge_rates", ["account_type_id"], name: "index_item_charge_rates_on_account_type_id", using: :btree

  create_table "journeys", force: :cascade do |t|
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "user_id",           limit: 4
    t.integer  "auxiliary_id",      limit: 4
    t.integer  "client_file_count", limit: 4
  end

  add_index "journeys", ["auxiliary_id"], name: "index_journeys_on_auxiliary_id", unique: true, using: :btree

  create_table "jurisdictions", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "ledgers", force: :cascade do |t|
    t.date     "date_paid"
    t.string   "narrative",           limit: 255
    t.integer  "amount_in_pennies",   limit: 4,   default: 0,     null: false
    t.string   "amount_in_currency",  limit: 255, default: "GBP", null: false
    t.integer  "amount_out_pennies",  limit: 4,   default: 0,     null: false
    t.string   "amount_out_currency", limit: 255, default: "GBP", null: false
    t.integer  "balance_pennies",     limit: 4,   default: 0,     null: false
    t.string   "balance_currency",    limit: 255, default: "GBP", null: false
    t.integer  "client_id",           limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "letters", force: :cascade do |t|
    t.datetime "letter_date"
    t.text     "description",          limit: 65535
    t.integer  "length",               limit: 4
    t.boolean  "chargeable"
    t.boolean  "high_legal"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "client_file_id",       limit: 4
    t.integer  "user_id",              limit: 4
    t.integer  "document_template_id", limit: 4
    t.string   "cabinet_location",     limit: 255
  end

  add_index "letters", ["client_file_id"], name: "index_letters_on_client_file_id", using: :btree
  add_index "letters", ["document_template_id"], name: "index_letters_on_document_template_id", using: :btree

  create_table "location_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.text     "address",          limit: 65535
    t.string   "telephone",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "location_type_id", limit: 4
  end

  add_index "locations", ["name"], name: "index_locations_on_name", unique: true, using: :btree

  create_table "meeting_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "meetings", force: :cascade do |t|
    t.text     "description",          limit: 65535
    t.string   "locus",                limit: 255
    t.integer  "length",               limit: 4
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "user_id",              limit: 4
    t.integer  "client_file_id",       limit: 4
    t.integer  "meeting_type_id",      limit: 4
    t.string   "attendance_with",      limit: 255
    t.integer  "journey_id",           limit: 4
    t.integer  "work_id",              limit: 4
    t.integer  "document_template_id", limit: 4
    t.integer  "witness_id",           limit: 4
    t.integer  "auxiliary_id",         limit: 4
    t.string   "cabinet_location",     limit: 255
    t.datetime "waiting_time_start"
    t.datetime "waiting_time_end"
  end

  add_index "meetings", ["auxiliary_id"], name: "index_meetings_on_auxiliary_id", using: :btree
  add_index "meetings", ["document_template_id"], name: "index_meetings_on_document_template_id", using: :btree
  add_index "meetings", ["journey_id"], name: "index_meetings_on_journey_id", using: :btree
  add_index "meetings", ["witness_id"], name: "index_meetings_on_witness_id", using: :btree
  add_index "meetings", ["work_id"], name: "index_meetings_on_work_id", using: :btree

  create_table "notifiable_join_entities", force: :cascade do |t|
    t.integer  "notification_id", limit: 4
    t.integer  "notifiable_id",   limit: 4
    t.string   "notifiable_type", limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "notifiable_join_entities", ["notifiable_type", "notifiable_id"], name: "index_notifiable_join_entities_on_notifiable_id", using: :btree
  add_index "notifiable_join_entities", ["notification_id"], name: "index_notifiable_join_entities_on_notification_id", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.string   "entity",     limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "notifications", ["entity"], name: "index_notifications_on_entity", unique: true, using: :btree

  create_table "payments", force: :cascade do |t|
    t.date     "payment_date"
    t.integer  "fee_amount_pennies",     limit: 4,   default: 0,     null: false
    t.string   "fee_amount_currency",    limit: 255, default: "GBP", null: false
    t.integer  "outlay_amount_pennies",  limit: 4,   default: 0,     null: false
    t.string   "outlay_amount_currency", limit: 255, default: "GBP", null: false
    t.integer  "claim_id",               limit: 4
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  add_index "payments", ["claim_id"], name: "index_payments_on_claim_id", using: :btree

  create_table "permissions", force: :cascade do |t|
    t.string   "subject_class", limit: 255
    t.string   "action",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "personal_details", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.string   "forename",    limit: 255
    t.string   "middlenames", limit: 255
    t.string   "surname",     limit: 255
    t.string   "initials",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phone_calls", force: :cascade do |t|
    t.string   "attendance_with", limit: 255
    t.text     "description",     limit: 65535
    t.boolean  "chargeable"
    t.integer  "client_file_id",  limit: 4
    t.integer  "user_id",         limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "phone_calls", ["client_file_id"], name: "index_phone_calls_on_client_file_id", using: :btree
  add_index "phone_calls", ["user_id"], name: "index_phone_calls_on_user_id", using: :btree

  create_table "police_authorities", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.text     "address",          limit: 65535
    t.string   "city",             limit: 255
    t.string   "police_constable", limit: 255
    t.string   "telephone",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "police_officers", force: :cascade do |t|
    t.string   "title",               limit: 255
    t.string   "name",                limit: 255
    t.string   "pc_number",           limit: 255
    t.integer  "police_authority_id", limit: 4
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "police_officers", ["police_authority_id"], name: "index_police_officers_on_police_authority_id", using: :btree

  create_table "precognitions", force: :cascade do |t|
    t.text     "description",          limit: 65535
    t.integer  "meeting_id",           limit: 4
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "document_template_id", limit: 4
    t.datetime "date_framed"
    t.integer  "length",               limit: 4
    t.string   "cabinet_location",     limit: 255
  end

  add_index "precognitions", ["document_template_id"], name: "index_precognitions_on_document_template_id", using: :btree
  add_index "precognitions", ["meeting_id"], name: "index_precognitions_on_meeting_id", using: :btree

  create_table "procurator_fiscals", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "address",    limit: 65535
    t.string   "telephone",  limit: 255
    t.string   "fax",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "procurator_fiscals", ["name"], name: "index_procurator_fiscals_on_name", unique: true, using: :btree

  create_table "templated_documents", force: :cascade do |t|
    t.string   "alfresco_id",                limit: 255
    t.string   "document_path",              limit: 255
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "document_templateable_id",   limit: 4
    t.string   "document_templateable_type", limit: 255
    t.integer  "document_template_id",       limit: 4
  end

  add_index "templated_documents", ["document_template_id"], name: "index_templated_documents_on_document_template_id", using: :btree
  add_index "templated_documents", ["document_templateable_type", "document_templateable_id"], name: "index_templated_documents_on_templated_docs", using: :btree

  create_table "travel_methods", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "travels", force: :cascade do |t|
    t.string   "origin",                 limit: 255
    t.string   "destination",            limit: 255
    t.integer  "mileage",                limit: 4
    t.integer  "parking_costs_pennies",  limit: 4,   default: 0,     null: false
    t.string   "parking_costs_currency", limit: 255, default: "GBP", null: false
    t.integer  "toll_costs_pennies",     limit: 4,   default: 0,     null: false
    t.string   "toll_costs_currency",    limit: 255, default: "GBP", null: false
    t.integer  "other_costs_pennies",    limit: 4,   default: 0,     null: false
    t.string   "other_costs_currency",   limit: 255, default: "GBP", null: false
    t.integer  "journey_id",             limit: 4
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.integer  "travel_method_id",       limit: 4
  end

  add_index "travels", ["journey_id"], name: "fk_rails_c0c10c9cdc", using: :btree
  add_index "travels", ["travel_method_id"], name: "index_travels_on_travel_method_id", using: :btree

  create_table "user_types", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.boolean  "qualified_solicitor"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "user_types", ["name"], name: "index_user_types_on_name", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username",               limit: 255
    t.integer  "id_number",              limit: 4
    t.integer  "access_code",            limit: 4
    t.integer  "personal_details_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  limit: 255, default: "",   null: false
    t.string   "encrypted_password",     limit: 255, default: "",   null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.integer  "auxiliary_id",           limit: 4
    t.integer  "user_type_id",           limit: 4
    t.boolean  "active",                             default: true
  end

  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["user_type_id"], name: "index_users_on_user_type_id", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "users_notifications", id: false, force: :cascade do |t|
    t.integer "user_id",         limit: 4
    t.integer "notification_id", limit: 4
  end

  add_index "users_notifications", ["notification_id", "user_id"], name: "index_users_notifications_on_notification_id_and_user_id", unique: true, using: :btree
  add_index "users_notifications", ["user_id"], name: "index_users_notifications_on_user_id", using: :btree

  create_table "witnesses", force: :cascade do |t|
    t.integer  "client_file_id",   limit: 4
    t.integer  "witnessable_id",   limit: 4
    t.string   "witnessable_type", limit: 255
    t.boolean  "cited"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "auxiliary_id",     limit: 4
  end

  add_index "witnesses", ["auxiliary_id"], name: "index_witnesses_on_auxiliary_id", using: :btree
  add_index "witnesses", ["client_file_id"], name: "index_witnesses_on_client_file_id", using: :btree
  add_index "witnesses", ["witnessable_type", "witnessable_id"], name: "index_witnesses_on_witnessable_type_and_witnessable_id", using: :btree

  create_table "works", force: :cascade do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean  "feed"
    t.integer  "user_id",       limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "auxiliary_id",  limit: 4
    t.integer  "workable_id",   limit: 4
    t.string   "workable_type", limit: 255
  end

  add_index "works", ["auxiliary_id"], name: "index_works_on_auxiliary_id", unique: true, using: :btree
  add_index "works", ["user_id"], name: "index_works_on_user_id", using: :btree
  add_index "works", ["workable_type", "workable_id"], name: "index_works_on_workable_type_and_workable_id", using: :btree

  add_foreign_key "account_charge_items", "accounts"
  add_foreign_key "account_charge_items", "item_charge_rates"
  add_foreign_key "account_increases", "accounts"
  add_foreign_key "account_types", "account_charge_rates"
  add_foreign_key "charge_items", "accounts"
  add_foreign_key "claims", "accounts"
  add_foreign_key "client_files", "clients"
  add_foreign_key "clients", "personal_details", column: "personal_details_id"
  add_foreign_key "court_attendances", "court_dates"
  add_foreign_key "court_date_types", "court_date_types", column: "following_court_date_type_id"
  add_foreign_key "court_dates", "client_files"
  add_foreign_key "court_dates", "court_date_types"
  add_foreign_key "court_dates", "courts"
  add_foreign_key "court_dates", "journeys"
  add_foreign_key "court_dates", "users"
  add_foreign_key "courts", "jurisdictions"
  add_foreign_key "debit_entries", "client_files"
  add_foreign_key "debit_entries", "document_templates"
  add_foreign_key "debit_entries", "users", column: "created_by_id"
  add_foreign_key "disclosures", "client_files"
  add_foreign_key "documents", "users", column: "created_by_id"
  add_foreign_key "file_forms", "client_files"
  add_foreign_key "file_forms", "document_templates"
  add_foreign_key "file_forms", "users", column: "created_by_id"
  add_foreign_key "file_forms", "witnesses"
  add_foreign_key "item_charge_rates", "account_types"
  add_foreign_key "letters", "document_templates"
  add_foreign_key "meetings", "document_templates"
  add_foreign_key "meetings", "journeys"
  add_foreign_key "meetings", "witnesses"
  add_foreign_key "meetings", "works"
  add_foreign_key "notifiable_join_entities", "notifications"
  add_foreign_key "payments", "claims"
  add_foreign_key "phone_calls", "client_files"
  add_foreign_key "phone_calls", "users"
  add_foreign_key "police_officers", "police_authorities"
  add_foreign_key "precognitions", "document_templates"
  add_foreign_key "precognitions", "meetings"
  add_foreign_key "templated_documents", "document_templates"
  add_foreign_key "travels", "journeys"
  add_foreign_key "travels", "travel_methods"
  add_foreign_key "users", "user_types"
  add_foreign_key "witnesses", "client_files"
  add_foreign_key "works", "users"
end
