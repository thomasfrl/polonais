class AddMainWordToWord < ActiveRecord::Migration[5.2]
  def change
    add_column :words, :main_word, :refererences, foreign_key: false
  end
end
