class Category < ApplicationRecord
  # Associations
  has_many :transactions
end
