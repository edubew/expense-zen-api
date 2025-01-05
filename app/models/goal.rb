class Goal < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :transactions

  # Validations
  validates :name, presence: true
  validates :status, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :start_date, presence: true
  validates :end_date, presence: true

  before_save :set_status

  private

  # Dynamically set the status based on progress and amount
  def set_status
    if progress >=amount
      self.status = 'Completed'
    elsif Date.today > end_date
      self.status = 'Failed'
    else
      self.status = 'Active'
    end
  end

  # Custom validation to ensure the end date doesn't come before the start date
  validate :end_date_cannot_be_before_start_date

  def end_date_cannot_be_before_start_date
    return unless end_date && start_date && end_date < start_date

    errors.add(:end_date, "can't be before the start date")
  end
end
