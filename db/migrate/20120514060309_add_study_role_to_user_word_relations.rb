class AddStudyRoleToUserWordRelations < ActiveRecord::Migration
  def self.up
    add_column :user_word_relations, :study_role, :integer
    add_index :user_word_relations, :study_role
  end

  def self.down
    remove_column :user_word_relations, :study_role
  end
end
