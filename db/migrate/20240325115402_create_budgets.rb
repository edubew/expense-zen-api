class CreateBudgets < ActiveRecord::Migration[7.1]
  def change
    create_table :budgets do |t|
      t.references :users, foreign_key: true
      t.references :category, foreign_key: true
      t.decimal :amount
      t.date :start_date
      t.date :end_date
      t.string :period

      t.timestamps
    end
  end
end
