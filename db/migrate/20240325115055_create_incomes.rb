class CreateIncomes < ActiveRecord::Migration[7.1]
  def change
    create_table :incomes do |t|
      t.references :user, foreign_key: true
      t.decimal: amount
      t.date: date
      t.string: source

      t.timestamps
    end
  end
end
