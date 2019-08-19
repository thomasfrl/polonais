class CreateFakeWords < ActiveRecord::Migration[5.2]
  def change
    create_table :fake_words do |t|
      t.string :content
      t.integer :counter
      t.timestamps
    end
  end
end
