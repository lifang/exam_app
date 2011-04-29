class AddDetailsToBlockQuestionRelations < ActiveRecord::Migration
  def self.up
    add_column :block_question_relations, :assecc_role, :integer
    add_column :block_question_relations, :is_in_user, :integer
  end

  def self.down
    remove_column :block_question_relations, :is_in_user
    remove_column :block_question_relations, :assecc_role
  end
end
