class AddProgressToGoals < ActiveRecord::Migration[7.1]
  def change
    add_column :goals, :progress, :decimal, default: 0.0
  end
end
