class CreateGrammaticalCases < ActiveRecord::Migration[5.2]
  def change
    create_table :grammatical_cases do |t|
      t.string :value
      t.timestamps
    end
  end
end
