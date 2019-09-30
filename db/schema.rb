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

ActiveRecord::Schema.define(version: 2019_08_26_120634) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "fake_words", force: :cascade do |t|
    t.string "content"
    t.integer "counter"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "words", force: :cascade do |t|
    t.boolean "main"
    t.string "content"
    t.string "traduction", default: [], array: true
    t.boolean "is_valid", default: false
    t.integer "type"
    t.integer "person"
    t.integer "grammatical_case"
    t.integer "number"
    t.bigint "fake_word_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "mode"
    t.integer "time"
    t.integer "aspect"
    t.bigint "main_word_id"
    t.index ["fake_word_id"], name: "index_words_on_fake_word_id"
    t.index ["main_word_id"], name: "index_words_on_main_word_id"
  end

end
