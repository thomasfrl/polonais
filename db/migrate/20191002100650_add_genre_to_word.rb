class AddGenreToWord < ActiveRecord::Migration[5.2]
  def change
    add_column :words, :genre, :integer, default: nil
  end
end
