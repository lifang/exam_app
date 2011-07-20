class AddPriceToExaminations < ActiveRecord::Migration
 def self.up
    add_column :examinations, :price, :integer, :defalut => 0
    add_column :examinations, :get_free_end_at , :datetime
    add_column :examinations, :exam_free_end_at , :datetime
  end

  def self.down
    remove_column :examinations, :price
    remove_column :examinations, :get_free_end_at
    remove_column :examinations, :exam_free_end_at
  end
end
