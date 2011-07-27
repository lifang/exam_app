class AddIsFreeToExamUsers < ActiveRecord::Migration
  def self.up
    add_column :exam_users, :is_free, :boolean, :default => 0
  end

  def self.down
    remove_column :exam_users, :is_free
  end
end
