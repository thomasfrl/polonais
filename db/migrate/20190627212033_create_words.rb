class CreateWords < ActiveRecord::Migration[5.2]
  def change
    create_table :words do |t|
      t.string :type
      t.boolean :main, default: nil
      t.integer :associated_ids, array: true, default: []
      t.integer :counter
      t.string :content
      t.string :traduction
      t.string :gram_case
      t.boolean :valid, default: false
      t.timestamps
    end
    add_index :words, :associated_ids, using: 'gin'
  end
end
