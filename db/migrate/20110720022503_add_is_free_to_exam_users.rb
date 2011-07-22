class AddIsFreeToExamUsers < ActiveRecord::Migration
  def self.up
    add_column :exam_users, :is_free, :boolean
  end

  def self.down
    remove_column :exam_users, :is_free
  end
end
