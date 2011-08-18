class AddScorePercentToQuestions < ActiveRecord::Migration
  def self.up
    add_column :questions, :score_percent, :ingeger
  end

  def self.down
    remove_column :questions, :score_percent
  end
end
