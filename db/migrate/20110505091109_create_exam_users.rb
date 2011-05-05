class CreateExamUsers < ActiveRecord::Migration
  def self.up
    create_table :exam_users do |t|
      t.integer :examination_id
      t.integer :user_id
      t.string :password
      t.boolean :user_affirm
      t.datetime :created_at
      t.integer :paper_id
      t.datetime :started_at
      t.datetime :submited_at
      t.datetime :ended_at
      t.boolean :is_submited
      t.boolean :open_to_user
      t.string :answer_sheet_url
      t.timestamps
    end
    add_index :exam_users,:examination_id
  end

  def self.down
    drop_table :exam_users
  end
end
