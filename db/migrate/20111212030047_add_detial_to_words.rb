class AddDetialToWords < ActiveRecord::Migration
  def self.up
    change_column :words, :types, :integer
    add_column :words, :phonetic, :string
    add_column :words, :enunciate_url, :string
  end

  def self.down
    change_column :words, :types, :string
    remove_column :words, :phonetic
    remove_column :words, :enunciate_url
  end
end
