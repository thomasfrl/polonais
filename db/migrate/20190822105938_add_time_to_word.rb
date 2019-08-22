class AddTimeToWord < ActiveRecord::Migration[5.2]
  def change
    add_column :words, :time, :integer, default: nil
  end
end
