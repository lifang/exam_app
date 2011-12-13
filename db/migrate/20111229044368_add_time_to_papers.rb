class AddTimeToPapers < ActiveRecord::Migration
  def self.up
    add_column :papers, :time, :integer
  end

  def self.down
    drop_table :papers
  end
end
