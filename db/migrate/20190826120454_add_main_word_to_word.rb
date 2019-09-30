class AddMainWordToWord < ActiveRecord::Migration[5.2]
  def change
    add_reference :words, :main_word, foreign_key: false
  end
end
