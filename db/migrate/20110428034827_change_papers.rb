class ChangePapers < ActiveRecord::Migration
  def self.up
    change_table :papers do |t|
      t.rename :types,:paper_category_id
    end
  end

end
