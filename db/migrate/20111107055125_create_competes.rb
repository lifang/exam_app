class CreateCompetes < ActiveRecord::Migration
  def self.up
    create_table :competes do |t|
      t.integer :user_id
      t.date :created_at
      t.integer :pirce
      t.string  :remark
    end
    add_index :competes, :user_id
  end

  def self.down
    drop_table :competes
  end
end
