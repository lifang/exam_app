class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :username
      t.string :mobilephone
      t.string :email
      t.string :address
      t.string :salt
      t.string :encrypted_password
      t.integer :status, :default => 0
      t.string :active_code
      t.string :code_id
      t.string :code_type
      
      t.timestamps
      
    end
    add_index :users,:name
    add_index :users,:email
    add_index :users,:status
    add_index :users,:code_id
    add_index :users,:code_type
  end

  def self.down
    drop_table :users
  end
end
