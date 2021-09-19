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

ActiveRecord::Schema.define(version: 20210509110753) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contracts", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "customer_id"
    t.string "building_number"
    t.string "contract_number"
    t.string "description"
    t.date "start_date"
    t.date "finish_date"
    t.integer "payment_type", limit: 2
    t.bigint "total_price"
    t.string "address"
    t.string "service_day"
    t.integer "stops", limit: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "insurance_type"
    t.decimal "lat", precision: 10, scale: 6
    t.decimal "lng", precision: 10, scale: 6
    t.integer "status", default: 0
    t.bigint "dept"
    t.index ["customer_id"], name: "index_contracts_on_customer_id"
    t.index ["user_id"], name: "index_contracts_on_user_id"
  end

  create_table "customer_transactions", force: :cascade do |t|
    t.bigint "customer_id"
    t.bigint "amount"
    t.bigint "dept"
    t.integer "payment_type"
    t.bigint "contract_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contract_id"], name: "index_customer_transactions_on_contract_id"
    t.index ["customer_id"], name: "index_customer_transactions_on_customer_id"
  end

  create_table "deny_reasons", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "deny_services", force: :cascade do |t|
    t.bigint "service_id"
    t.bigint "user_id"
    t.bigint "deny_reason_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "handled", default: false
    t.index ["deny_reason_id"], name: "index_deny_services_on_deny_reason_id"
    t.index ["service_id"], name: "index_deny_services_on_service_id"
    t.index ["user_id"], name: "index_deny_services_on_user_id"
  end

  create_table "elevators", force: :cascade do |t|
    t.bigint "contract_id"
    t.string "name"
    t.string "serial_number"
    t.integer "elevator_type", limit: 2
    t.integer "usage", limit: 2
    t.integer "capacity", limit: 2
    t.integer "floors", limit: 2
    t.integer "stops", limit: 2
    t.integer "swing", limit: 2
    t.integer "automatic", limit: 2
    t.integer "door_type", limit: 2
    t.string "door_name"
    t.integer "engine_room", limit: 2
    t.integer "suspension_type", limit: 2
    t.integer "engine_type", limit: 2
    t.string "engine"
    t.float "power"
    t.integer "panel_type", limit: 2
    t.string "panel_name"
    t.string "drive"
    t.integer "feedback", limit: 2
    t.integer "car_communication", limit: 2
    t.string "speed"
    t.integer "emergency_system", limit: 2
    t.bigint "insurance_id"
    t.string "insurance_finish_date"
    t.string "insurance_date"
    t.bigint "standard_id"
    t.string "standard_finish_date"
    t.integer "standard_type", limit: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contract_id"], name: "index_elevators_on_contract_id"
    t.index ["insurance_id"], name: "index_elevators_on_insurance_id"
    t.index ["standard_id"], name: "index_elevators_on_standard_id"
  end

  create_table "insurances", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "message_statuses", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "message_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id"], name: "index_message_statuses_on_message_id"
    t.index ["user_id"], name: "index_message_statuses_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string "title"
    t.string "body"
    t.bigint "to_id"
    t.integer "message_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.index ["to_id"], name: "index_messages_on_to_id"
  end

  create_table "reasons", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "service_items", force: :cascade do |t|
    t.bigint "service_id"
    t.bigint "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_service_items_on_item_id"
    t.index ["service_id"], name: "index_service_items_on_service_id"
  end

  create_table "service_parts", force: :cascade do |t|
    t.bigint "service_id"
    t.string "name"
    t.integer "qty", limit: 2
    t.bigint "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_service_parts_on_service_id"
  end

  create_table "services", force: :cascade do |t|
    t.bigint "contract_id"
    t.bigint "user_id"
    t.integer "request_type", limit: 2
    t.integer "status", limit: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "reason_id", limit: 2
    t.date "service_date"
    t.decimal "lat", precision: 10, scale: 6
    t.decimal "lng", precision: 10, scale: 6
    t.index ["contract_id"], name: "index_services_on_contract_id"
    t.index ["user_id"], name: "index_services_on_user_id"
  end

  create_table "standards", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.string "password_digest"
    t.integer "role", limit: 2
    t.integer "gender", limit: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status"
    t.string "cell"
    t.string "firebase_token"
  end

  add_foreign_key "contracts", "users"
  add_foreign_key "contracts", "users", column: "customer_id"
  add_foreign_key "customer_transactions", "contracts"
  add_foreign_key "customer_transactions", "users", column: "customer_id"
  add_foreign_key "deny_services", "deny_reasons"
  add_foreign_key "deny_services", "services"
  add_foreign_key "deny_services", "users"
  add_foreign_key "elevators", "contracts"
  add_foreign_key "elevators", "insurances"
  add_foreign_key "elevators", "standards"
  add_foreign_key "message_statuses", "messages"
  add_foreign_key "message_statuses", "users"
  add_foreign_key "messages", "users", column: "to_id"
  add_foreign_key "service_items", "items"
  add_foreign_key "service_items", "services"
  add_foreign_key "service_parts", "services"
  add_foreign_key "services", "contracts"
  add_foreign_key "services", "users"
end
