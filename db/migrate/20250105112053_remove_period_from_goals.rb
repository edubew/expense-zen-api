class RemovePeriodFromGoals < ActiveRecord::Migration[7.1]
  def change
    remove_column :goals, :period, :string
  end
end
