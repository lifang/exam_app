class CreateProofs < ActiveRecord::Migration
  def self.up
    create_table :proofs do |t|
      t.string :text
      t.integer :user_id, :null => false
      t.boolean :checked
    end
  end

  def self.down
  end
end
