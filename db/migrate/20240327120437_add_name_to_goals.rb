class AddNameToGoals < ActiveRecord::Migration[7.1]
  def change
    add_column :goals, :name, :string
  end
end
