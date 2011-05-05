class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :username
      t.string :mobilephone
      t.datetime :created_at
      t.string :address
      t.datetime :updated_at
      t.string :salt
      t.string :encrypted_password
      t.integer :status
      t.string :active_code

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
