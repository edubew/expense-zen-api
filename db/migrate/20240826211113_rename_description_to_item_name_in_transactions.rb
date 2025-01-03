class RenameDescriptionToItemNameInTransactions < ActiveRecord::Migration[7.1]
  def change
    rename_column :transactions, :description, :item_name
  end
end
