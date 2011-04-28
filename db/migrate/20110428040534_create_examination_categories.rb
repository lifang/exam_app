class CreateExaminationCategories < ActiveRecord::Migration
  def self.up
    create_table :examination_categories do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :examination_categories
  end
end
