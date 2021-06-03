# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_06_02_140904) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chatroom_bans", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "end_time", null: false
    t.bigint "user_id", null: false
    t.bigint "chatroom_id", null: false
  end

  create_table "chatroom_mutes", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "end_time", null: false
    t.bigint "user_id", null: false
    t.bigint "chatroom_id", null: false
  end

  create_table "chatrooms", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "chatroom_type", null: false
    t.string "password"
    t.bigint "owner", null: false
    t.bigint "admin", default: [], array: true
    t.bigint "banned", default: [], array: true
    t.bigint "members", default: [], array: true
    t.bigint "muted", default: [], array: true
    t.index ["name"], name: "index_chatrooms_on_name", unique: true
    t.index ["owner"], name: "index_chatrooms_on_owner"
  end

  create_table "chats", force: :cascade do |t|
    t.string "message"
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.bigint "user_id"
    t.bigint "chatroom_id"
    t.string "date_creation"
    t.index ["chatroom_id"], name: "index_chats_on_chatroom_id"
    t.index ["user_id"], name: "index_chats_on_user_id"
  end

  create_table "friends", force: :cascade do |t|
    t.bigint "user_one_id"
    t.bigint "user_two_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "pending"
  end

  create_table "games", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "guild_invitations", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "guild_id"
    t.boolean "pending"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "guild_wars", force: :cascade do |t|
    t.datetime "start"
    t.datetime "end"
    t.bigint "prize"
    t.bigint "guild_one_id"
    t.bigint "guild_two_id"
    t.bigint "guild_one_points"
    t.bigint "guild_two_points"
    t.bigint "unanswered_match"
    t.boolean "tournaments", default: false
    t.boolean "ladder", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "pending"
    t.boolean "done"
    t.boolean "started"
    t.bigint "unanswered_guild_one", default: 0
    t.bigint "unanswered_guild_two", default: 0
    t.bigint "winner"
    t.bigint "looser"
    t.boolean "tie", default: false
    t.datetime "start_war_time"
    t.datetime "end_war_time"
    t.boolean "war_time"
  end

  create_table "guilds", force: :cascade do |t|
    t.string "name"
    t.string "anagram"
    t.integer "points"
    t.bigint "owner"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "win"
    t.bigint "loose"
    t.bigint "war"
  end

  create_table "matches", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "pongs", force: :cascade do |t|
    t.bigint "user_left_id"
    t.bigint "user_right_id"
    t.bigint "user_left_score"
    t.bigint "user_right_score"
    t.string "mode"
    t.boolean "pending"
    t.boolean "started"
    t.boolean "done"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "playing"
    t.bigint "winner"
    t.bigint "looser"
    t.boolean "tie"
    t.bigint "room_id"
  end

  create_table "private_messages", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "message"
    t.bigint "user_id", null: false
    t.bigint "private_room_id", null: false
    t.string "date_creation"
    t.index ["private_room_id"], name: "index_private_messages_on_private_room_id"
    t.index ["user_id"], name: "index_private_messages_on_user_id"
  end

  create_table "private_rooms", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users", default: [], array: true
  end

  create_table "tournaments", force: :cascade do |t|
    t.datetime "start_time"
    t.bigint "winner"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_reward", default: 0
    t.bigint "guild_reward", default: 0
    t.boolean "started", default: false
    t.bigint "m_playing"
    t.bigint "m_ended"
    t.boolean "auto", default: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "username"
    t.string "avatar"
    t.bigint "block_list", default: [], array: true
    t.bigint "guild"
    t.boolean "officer"
    t.boolean "admin", default: false
    t.boolean "superuser", default: false
    t.boolean "banned", default: false
    t.boolean "online", default: false
    t.string "encrypted_otp_secret"
    t.string "encrypted_otp_secret_iv"
    t.string "encrypted_otp_secret_salt"
    t.integer "consumed_timestep"
    t.boolean "otp_required_for_login", default: false
    t.string "provider"
    t.string "uid"
    t.boolean "first_time", default: true
    t.boolean "member"
    t.bigint "score", default: 1000
    t.bigint "pong", default: 0
    t.bigint "tournament"
    t.boolean "eliminated", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["provider"], name: "index_users_on_provider"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid"], name: "index_users_on_uid"
  end

  add_foreign_key "chatrooms", "users", column: "owner"
  add_foreign_key "chats", "chatrooms"
  add_foreign_key "chats", "users"
  add_foreign_key "private_messages", "private_rooms"
  add_foreign_key "private_messages", "users"
end
