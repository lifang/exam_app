class CreateExamUsers < ActiveRecord::Migration
  def self.up
    create_table :exam_users do |t|
      t.integer :exam_plan_id
      t.string :name
      t.string :password
      t.string :mobilephone
      t.string :email
      t.string :comfir_password
      t.boolean :user_affirm

      t.timestamps
    end
    add_index :exam_users,:exam_plan_id
  end

  def self.down
    drop_table :exam_users
  end
end
