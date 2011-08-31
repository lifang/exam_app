class CreateFeedbacks < ActiveRecord::Migration
  def self.up
    create_table :feedbacks do |t|
      t.integer :user_id
      t.boolean :status, :default => 0
      t.text  :description
      t.string :answer
      t.datetime :created_at
    end
    add_index :feedbacks,:user_id
    add_index :feedbacks,:status
  end

  def self.down
    drop_table :feedbacks
  end
end
