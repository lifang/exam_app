class CreateCourses < ActiveRecord::Migration
  def self.up
    create_table :courses do |t|
      t.string :title
      t.text :description
      t.date :created_at
    end
    add_index :courses,:title
  end

  def self.down
    drop_table :courses
  end
end
