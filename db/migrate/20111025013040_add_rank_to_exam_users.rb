class AddRankToExamUsers < ActiveRecord::Migration
  def self.up
    add_column :exam_users, :rank, :string
  end

  def self.down
    remove_column :exam_users, :rank
  end
end
