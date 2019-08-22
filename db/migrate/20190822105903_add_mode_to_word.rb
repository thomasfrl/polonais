class AddModeToWord < ActiveRecord::Migration[5.2]
  def change
    add_column :words, :mode, :integer, default: nil
  end
end
