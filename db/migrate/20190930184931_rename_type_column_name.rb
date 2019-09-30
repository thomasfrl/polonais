class RenameTypeColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :words, :type, :category
  end
end
