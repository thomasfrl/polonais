class CreateWords < ActiveRecord::Migration[5.2]
  def change
    create_table :words do |t|
      t.boolean :main, default: nil
      t.string :content
      t.string :traduction, array: true, default: []
      t.boolean :is_valid, default: false
      t.integer :word_ids, array: true, default: []
      t.integer :type, default: nil
      t.integer :person, default: nil
      t.integer :grammatical_case, default: nil
      t.integer :number, default: nil
      t.references :fake_word, foreign_key: false
      t.timestamps
    end
    add_index :words, :word_ids, using: 'gin'
  end
end
