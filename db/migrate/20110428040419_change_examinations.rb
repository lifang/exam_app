class ChangeExaminations < ActiveRecord::Migration
  def self.up
    change_table :examinations do |t|
      t.rename :types,:examination_category_id
    end
  end

  def self.down
  end
end
