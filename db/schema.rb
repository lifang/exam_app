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

ActiveRecord::Schema.define(:version => 20110506091745) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exam_raters", :force => true do |t|
    t.datetime "created_at"
    t.string   "name"
    t.string   "mobilephone"
    t.string   "email"
    t.string   "author_code"
    t.datetime "updated_at"
  end

  create_table "exam_users", :force => true do |t|
    t.integer  "examination_id"
    t.integer  "user_id"
    t.string   "password"
    t.boolean  "user_affirm"
    t.datetime "created_at"
    t.integer  "paper_id"
    t.datetime "started_at"
    t.datetime "submited_at"
    t.datetime "ended_at"
    t.boolean  "is_submited"
    t.boolean  "open_to_user"
    t.string   "answer_sheet_url"
    t.datetime "updated_at"
  end

  add_index "exam_users", ["examination_id"], :name => "index_exam_users_on_examination_id"
  add_index "exam_users", ["paper_id"], :name => "index_exam_users_on_paper_id"
  add_index "exam_users", ["user_id"], :name => "index_exam_users_on_user_id"

  create_table "examination_paper_relations", :force => true do |t|
    t.integer  "examination_id"
    t.integer  "paper_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "examination_paper_relations", ["examination_id"], :name => "index_examination_paper_relations_on_examination_id"
  add_index "examination_paper_relations", ["paper_id"], :name => "index_examination_paper_relations_on_paper_id"

  create_table "examinations", :force => true do |t|
    t.string   "title"
    t.integer  "creater_id"
    t.string   "description"
    t.boolean  "is_score_open"
    t.boolean  "is_paper_open"
    t.string   "exam_password1"
    t.string   "exam_password2"
    t.datetime "start_at_time"
    t.datetime "start_end_time"
    t.datetime "exam_time"
    t.boolean  "is_published"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "examinations", ["creater_id"], :name => "index_examinations_on_creater_id"

  create_table "paper_blocks", :force => true do |t|
    t.integer  "paper_id"
    t.text     "title"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "paper_blocks", ["paper_id"], :name => "index_paper_blocks_on_paper_id"

  create_table "papers", :force => true do |t|
    t.integer  "category_id"
    t.text     "title"
    t.integer  "creater_id"
    t.string   "description"
    t.integer  "total_score"
    t.integer  "total_question_num"
    t.boolean  "is_used"
    t.string   "paper_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "papers", ["category_id"], :name => "index_papers_on_category_id"

  create_table "problem_tag_relations", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "problem_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "problem_tag_relations", ["problem_id"], :name => "index_problem_tag_relations_on_problem_id"
  add_index "problem_tag_relations", ["tag_id"], :name => "index_problem_tag_relations_on_tag_id"

  create_table "problem_tags", :force => true do |t|
    t.integer  "problem_id"
    t.integer  "total_num"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "problem_tags", ["problem_id"], :name => "index_problem_tags_on_problem_id"

  create_table "problems", :force => true do |t|
    t.integer  "category_id"
    t.text     "title"
    t.integer  "types"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "problems", ["category_id"], :name => "index_problems_on_category_id"

  create_table "questions", :force => true do |t|
    t.integer "problem_id"
    t.string  "description"
    t.string  "answer"
    t.integer "correct_type"
    t.text    "analysis"
    t.string  "question_attrs"
  end

  add_index "questions", ["problem_id"], :name => "index_questions_on_problem_id"

  create_table "rater_user_relations", :force => true do |t|
    t.integer  "exam_user_id"
    t.integer  "exam_rater_id"
    t.boolean  "is_marked"
    t.integer  "examination_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "score_levels", :force => true do |t|
    t.integer  "examination_id"
    t.string   "key"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "score_levels", ["examination_id"], :name => "index_score_levels_on_examination_id"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "user_role_relations", :force => true do |t|
    t.integer  "role_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_role_relations", ["role_id"], :name => "index_user_role_relations_on_role_id"
  add_index "user_role_relations", ["user_id"], :name => "index_user_role_relations_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "username"
    t.string   "mobilephone"
    t.datetime "created_at"
    t.string   "address"
    t.datetime "updated_at"
    t.string   "salt"
    t.string   "encrypted_password"
    t.integer  "status"
    t.string   "active_code"
  end

end
