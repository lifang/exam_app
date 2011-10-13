class CreateReportErrors < ActiveRecord::Migration
  def self.up
    create_table :report_errors do |t|
      t.integer :paper_id
      t.string :paper_title
      t.integer :user_id
      t.string :user_name
      t.integer :error_type
      t.integer :question_index
      t.timestamps
    end
  end

  def self.down
    drop_table :report_errors
  end
end
