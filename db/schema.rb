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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110426084352) do

  create_table "block_question_relations", :force => true do |t|
    t.integer "question_id"
    t.integer "paper_block_id"
    t.integer "score"
  end

  add_index "block_question_relations", ["paper_block_id"], :name => "index_block_question_relations_on_paper_block_id"
  add_index "block_question_relations", ["question_id"], :name => "index_block_question_relations_on_question_id"

  create_table "exam_plans", :force => true do |t|
    t.integer  "examnation_id"
    t.datetime "start_at_time"
    t.integer  "creater_id"
    t.string   "description"
    t.datetime "start_end_time"
    t.datetime "exam_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "exam_plans", ["creater_id"], :name => "index_exam_plans_on_creater_id"
  add_index "exam_plans", ["examnation_id"], :name => "index_exam_plans_on_examnation_id"

  create_table "exam_raters", :force => true do |t|
    t.integer "exam_plan_id"
    t.string  "name"
    t.string  "password"
    t.string  "mobilephone"
    t.string  "email"
  end

  add_index "exam_raters", ["exam_plan_id"], :name => "index_exam_raters_on_exam_plan_id"

  create_table "exam_records", :force => true do |t|
    t.integer "exam_user_id"
    t.integer "examination_id"
    t.boolean "is_submited"
    t.boolean "is_marked"
    t.string  "answer_sheet_url"
  end

  add_index "exam_records", ["exam_user_id"], :name => "index_exam_records_on_exam_user_id"
  add_index "exam_records", ["examination_id"], :name => "index_exam_records_on_examination_id"

  create_table "exam_users", :force => true do |t|
    t.integer "exam_plan_id"
    t.string  "name"
    t.string  "password"
    t.string  "mobilephone"
    t.string  "email"
    t.string  "comfir_password"
    t.boolean "user_affirm"
  end

  add_index "exam_users", ["exam_plan_id"], :name => "index_exam_users_on_exam_plan_id"

  create_table "examnations", :force => true do |t|
    t.integer  "paper_id"
    t.string   "title"
    t.integer  "types"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "examnations", ["paper_id"], :name => "index_examnations_on_paper_id"

  create_table "paper_blocks", :force => true do |t|
    t.integer  "paper_id"
    t.string   "title"
    t.integer  "types"
    t.string   "description"
    t.integer  "block_total_score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "paper_blocks", ["paper_id"], :name => "index_paper_blocks_on_paper_id"

  create_table "papers", :force => true do |t|
    t.string   "title"
    t.string   "types"
    t.integer  "creater_id"
    t.string   "description"
    t.integer  "total_score"
    t.integer  "total_question_num"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "question_attrs", :force => true do |t|
    t.integer "question_point_id"
    t.string  "key"
    t.string  "value"
  end

  add_index "question_attrs", ["question_point_id"], :name => "index_question_attrs_on_question_point_id"

  create_table "question_categories", :force => true do |t|
    t.string "name"
  end

  create_table "question_points", :force => true do |t|
    t.integer "question_id"
    t.string  "description"
    t.string  "answer"
    t.integer "correct_type"
  end

  create_table "question_tag_relations", :force => true do |t|
    t.integer "tag_id"
    t.integer "question_id"
  end

  add_index "question_tag_relations", ["question_id"], :name => "index_question_tag_relations_on_question_id"
  add_index "question_tag_relations", ["tag_id"], :name => "index_question_tag_relations_on_tag_id"

  create_table "question_tags", :force => true do |t|
    t.integer "question_id"
    t.integer "total_num"
  end

  add_index "question_tags", ["question_id"], :name => "index_question_tags_on_question_id"

  create_table "questions", :force => true do |t|
    t.integer  "question_category_id"
    t.string   "title"
    t.integer  "types"
    t.boolean  "is_used"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["question_category_id"], :name => "index_questions_on_question_category_id"

  create_table "rater_record_relations", :force => true do |t|
    t.integer "exam_record_id"
    t.integer "exam_rater_id"
  end

  add_index "rater_record_relations", ["exam_rater_id"], :name => "index_rater_record_relations_on_exam_rater_id"
  add_index "rater_record_relations", ["exam_record_id"], :name => "index_rater_record_relations_on_exam_record_id"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "user_name"
    t.string   "password"
    t.string   "password_confirmation"
    t.string   "mobilephone"
    t.string   "email"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
