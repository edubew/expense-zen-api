class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.references :user, foreign_key: true
      t.references :category, foreign_key: true
      t.references :goal, foreign_key: true
      t.decimal :amount
      t.date :date
      t.string :description

      t.timestamps
    end
  end
end
