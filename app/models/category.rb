class Category < ApplicationRecord
  # Associations
  has_many :transactions, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :icon, presence: true

  def total_amount
    transactions.sum(:amount)
  end
end