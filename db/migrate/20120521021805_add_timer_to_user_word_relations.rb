class AddTimerToUserWordRelations < ActiveRecord::Migration
  def self.up
    add_column :user_word_relations, :timer, :string
  end

  def self.down
    remove_column :user_word_relations, :timer
  end
end
