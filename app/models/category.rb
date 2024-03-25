class Category < ApplicationRecord
  # Associations
  has_many :transactions
  has_many :budgets
end
