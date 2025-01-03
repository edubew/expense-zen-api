class Transaction < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :category

  # Validations
  validates :date, presence: true
  validates :item_name, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
end
