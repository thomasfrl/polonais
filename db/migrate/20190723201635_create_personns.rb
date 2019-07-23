class CreatePersonns < ActiveRecord::Migration[5.2]
  def change
    create_table :personns do |t|
      t.string :value
      t.timestamps
    end
  end
end
