class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :user_name
      t.string :password
      t.string :password_confirmation
      t.string :mobilephone
      t.string :email
      t.string :address

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
