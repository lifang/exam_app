class AddColumnsToUserWordRelations < ActiveRecord::Migration
  def self.up
    add_column :user_word_relations, :login_time, :datetime
    add_column :user_word_relations, :all_study_time, :integer, :default => 0
    add_column :user_word_relations, :practice_url, :string
    add_index :user_word_relations, :login_time
    add_index :user_word_relations, :all_study_time
    add_index :user_word_relations, :practice_url
  end

  def self.down
    remove_column :user_word_relations, :login_time
    remove_column :user_word_relations, :all_study_time
    remove_column :user_word_relations, :practice_url
  end
end
