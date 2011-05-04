class AddIsOpenToExamination < ActiveRecord::Migration
  def self.up
    add_column :examinations, :is_open, :boolean
  end

  def self.down
    remove_column :examinations, :is_open
  end
end
