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

ActiveRecord::Schema.define(version: 20150308042726) do

  create_table "activities", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fixtures", force: true do |t|
    t.integer  "tournament_id"
    t.integer  "player1_id"
    t.integer  "player1_score"
    t.integer  "player2_id"
    t.integer  "player2_score"
    t.boolean  "completed"
    t.string   "current_stage"
    t.integer  "next_playoff_id"
    t.datetime "start_time"
    t.integer  "playoff_round"
    t.integer  "winner_id"
    t.integer  "game_number"
    t.integer  "preceding_playoff_game_number1"
    t.integer  "preceding_playoff_game_number2"
    t.integer  "league_round"
    t.boolean  "bye"
    t.integer  "preceding_league_pool"
    t.integer  "preceding_league_ranking1"
    t.integer  "preceding_league_ranking2"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "location"
    t.string   "referee"
  end

  create_table "participants", force: true do |t|
    t.integer  "tournament_id"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "players", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "standings", force: true do |t|
    t.integer  "tournament_id"
    t.integer  "team_id"
    t.integer  "points"
    t.integer  "for"
    t.integer  "against"
    t.integer  "difference"
    t.integer  "wins"
    t.integer  "draws"
    t.integer  "losses"
    t.integer  "games_played"
    t.integer  "placing"
    t.boolean  "equal_placing"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tournaments", force: true do |t|
    t.string   "name"
    t.integer  "activity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "winner_id"
    t.boolean  "completed"
    t.string   "format"
    t.integer  "teams_in_playoffs"
    t.string   "location"
    t.string   "organisation"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
