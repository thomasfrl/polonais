class CreateWords < ActiveRecord::Migration[5.2]
  def change
    create_table :words do |t|
      t.boolean :main, default: nil
      t.string :content
      t.string :traduction, array: true, default: []
      t.boolean :valid, default: false
      t.integer :word, default: nil
      t.integer :type, default: nil
      t.integer :person, default: nil
      t.integer :grammatical_case, default: nil
      t.integer :number, default: nil
      t.timestamps
      t.integer :counter, default: nil
    end
    add_index :words, :associated_ids, using: 'gin'
  end
end
