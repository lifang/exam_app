class CreateInviteCodes < ActiveRecord::Migration
  def self.up
    create_table :invite_codes do |t|
      t.string :code
      t.boolean :is_used
      t.datetime :use_time
    end
  end

  def self.down
    drop_table :invite_codes
  end
end
