class Api::V1::GoalsController < ApplicationController
  before_action :authenticate_user
  before_action :set_goal, only: [:update, :destroy, :show]

  # Create a new financial goal
  def create
    goal = current_user.goals.new(goal_params)
    if goal.save
      render json: { message: 'Goal created successfully🎉' }, status: :created
    else
      render json: { error: 'Unable to create goal' }, status: :unprocessable_entity
    end
  end

  # Update an existing goal
  def update
    if @goal.update(goal_params)
      render json: { message: 'Goal updated successfully🎉' }, status: :ok
    else
      render json: { error: @goal.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Delete a goal
  def destroy
    if @goal.destroy
      render json: { message: 'Goal deleted successfully' }, status: :ok
    else
      render json: { error: 'Unable to delete goal' }, status: :unprocessable_entity
    end
  end

  # Show details and progress for a specific goal
  def show
    render json: @goal, include: [:transactions], status: :ok
  end

  # List all user's goals
  def index
    goals = current_user.goals
    render json: goals, status: :ok
  end

  # Compare goals and track progress
  def compare
    # Will come back to this later
  end

  private

  def goal_params
    params.require(:goal).permit(:amount, :name, :status, :period, :start_date, :end_date)
  end

  def set_goal
    @goal = current_user.goals.find(params[:id])
  end
end
