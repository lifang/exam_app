class AddChMeanToWordSentences < ActiveRecord::Migration
  def self.up
    add_column :word_sentences, :ch_mean, :string
  end

  def self.down
    remove_column :word_sentences, :ch_mean
  end
end
