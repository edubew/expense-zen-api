class Goal < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :transactions

  # Validations
  validates :name, presence: true
  validates :status, presence: true
  validates :period, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :start_date, presence: true
  validates :end_date, presence: true

  # Calculate the difference between target and progress
  def progress_difference
    (progress || 0) - amount
  end

  private

  def progress_within_limit
    errors.add(:progress, "cannot exceed goal anount") if progress && progress > amount
  end

  # Custom validation to ensure the end date doesn't come before the start date
  validate :end_date_cannot_be_before_start_date

  def end_date_cannot_be_before_start_date
    return unless end_date && start_date && end_date < start_date

    errors.add(:end_date, "can't be before the start date")
  end
end
