class AddUserAffirmToExaminations < ActiveRecord::Migration
  def self.up
    add_column :examinations, :user_affirm, :boolean
  end

  def self.down
    remove_column :examinations, :user_affirm
  end
end
