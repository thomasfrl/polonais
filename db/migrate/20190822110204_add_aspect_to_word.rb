class AddAspectToWord < ActiveRecord::Migration[5.2]
  def change
    add_column :words, :aspect, :integer, default: nil
  end
end
