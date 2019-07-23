class CreateWords < ActiveRecord::Migration[5.2]
  def change
    create_table :words do |t|
      t.boolean :main, default: nil
      t.string :content
      t.string :traduction, array: true, default: []
      t.boolean :valid, default: false
      t.integer :word_ids, array: true, default: []
      t.integer :type_ids, array: true, default: []
      t.integer :person_ids, array: true, default: []
      t.integer :grammatical_case_ids, array: true, default: []
      t.integer :number_ids, array: true, default: []
      t.timestamps
      t.integer :counter, default: nil
    end
    add_index :words, :associated_ids, using: 'gin'
  end
end
