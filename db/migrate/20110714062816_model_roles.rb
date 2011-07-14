class ModelRoles < ActiveRecord::Migration
  def self.up
    create_table:model_roles do |t|
      t.integer :role_id
      t.integer :right_sum
    end
  end

  def self.down
    drop_table :model_roles
  end
end
