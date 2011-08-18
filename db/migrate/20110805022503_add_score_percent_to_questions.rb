class AddScorePercentToQuestions < ActiveRecord::Migration
  def self.up
    add_column :questions, :score_percent, :integer
  end

  def self.down
    remove_column :questions, :score_percent
  end
end
