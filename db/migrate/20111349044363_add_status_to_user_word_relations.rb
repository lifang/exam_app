class AddStatusToUserWordRelations < ActiveRecord::Migration
  def self.up
    add_column :user_word_relations, :status, :boolean
    add_index :user_word_relations, :status
  end

  def self.down
    remove_column :user_word_relations, :status
  end
end
