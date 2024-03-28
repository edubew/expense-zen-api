class Income < ApplicationRecord
  # Associations
  belongs_to :user

  # Validations
  validates :amount, presence: true, numericality: { greater_than: 0}
  validates :source, presence: true
  validates :date, presence: true
end
