class Goal < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :transactions
end
