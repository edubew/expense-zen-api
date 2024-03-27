class CreateGoals < ActiveRecord::Migration[7.1]
  def change
    create_table :goals do |t|
      t.references :user, foreign_key: true
      t.decimal :amount
      t.date :start_date
      t.date :end_date
      t.string :period

      t.timestamps
    end
  end
end
