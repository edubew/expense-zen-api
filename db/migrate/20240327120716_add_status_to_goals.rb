class AddStatusToGoals < ActiveRecord::Migration[7.1]
  def change
    add_column :goals, :status, :string
  end
end
