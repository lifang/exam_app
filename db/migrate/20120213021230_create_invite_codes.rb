class CreateInviteCodes < ActiveRecord::Migration
  def self.up
    create_table :invite_codes do |t|
      t.string :code
      t.datetime :created_at
      t.integer :vicegerent_id
      t.integer :user_id
      t.integer :bus_id
      t.datetime :use_time
    end
    add_index :invite_codes, :code
    add_index :invite_codes, :vicegerent_id
    add_index :invite_codes, :user_id
    add_index :invite_codes, :created_at
  end

  def self.down
    drop_table :invite_codes
  end
end
