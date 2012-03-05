class AddDetialToUserWordRelation < ActiveRecord::Migration
  def self.up
    add_column :user_word_relations, :nomal_ids, :text
    add_column :user_word_relations, :recite_ids, :text
    add_column :user_word_relations, :category_id, :integer
    remove_column :user_word_relations, :word_id
    remove_column :user_word_relations, :status
  end

  def self.down
    remove_column :user_word_relations, :nomal_ids
    remove_column :user_word_relations, :recite_ids
    remove_column :user_word_relations, :category_id
    add_column :user_word_relations, :word_id, :integer
    add_column :user_word_relations, :status, :boolean
  end
end
