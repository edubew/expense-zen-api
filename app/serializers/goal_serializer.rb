class GoalSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :amount, :start_date, :end_date, :created_at, :updated_at, :name, :status, :progress, :progress_difference, :status_message

  def amount
    object.amount.to_f
  end

  def progress
    object.progress.to_f
  end

  def progress_difference
    object.progress_difference.to_f
  end
end