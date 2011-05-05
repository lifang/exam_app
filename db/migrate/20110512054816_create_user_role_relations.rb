class CreateUserRoleRelations < ActiveRecord::Migration
  def self.up
    create_table :user_role_relations do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :user_role_relations
  end
end
