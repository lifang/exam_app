class ModelRoles < ActiveRecord::Migration
  def self.up
    create_table :model_roles do |t|
      t.integer :role_id
      t.integer :right_sum
    end
    add_index :model_roles, :role_id
  end

  def self.down
    drop_table :model_roles
  end
end
