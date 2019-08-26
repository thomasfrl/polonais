class RemoveColumnToWord < ActiveRecord::Migration[5.2]
  def change
    change_table :words do |t|
      t.remove :word_ids
    end
  end
end
