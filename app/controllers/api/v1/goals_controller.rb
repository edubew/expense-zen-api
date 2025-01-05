class Api::V1::GoalsController < ApplicationController
  before_action :authenticate_user
  before_action :set_goal, only: %i[update destroy show deposit]

  # Create a new financial goal(POST)
  def create
    goal = current_user.goals.new(goal_params)
    if goal.save
      render json: { message: 'Goal created successfully🎉' }, status: :created
    else
      render json: { error: 'Unable to create goal' }, status: :unprocessable_entity
    end
  end

  # Update an existing goal(PUT)
  def update
    if @goal.update(goal_params)
      render json: { message: 'Goal updated successfully🎉' }, status: :ok
    else
      render json: { error: @goal.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Delete a goal(DELETE)
  def destroy
    if @goal.destroy
      render json: { message: 'Goal deleted successfully' }, status: :ok
    else
      render json: { error: 'Unable to delete goal' }, status: :unprocessable_entity
    end
  end

  # Show details and progress for a specific goal
  def show
    render json: {
      goal: @goal,
      progress_difference: @goal.progress_difference,
      status: status_message(@goal.progress_difference)
    }, include: [:transactions], status: :ok
    # render json: @goal, include: [:transactions], status: :ok
  end

  # List all user's goals(GET)
  def index
    goals = current_user.goals.map do |goal|
      goal.as_json.merge(
        progress_difference: goal.progress_difference,
        status: status_message(goal.progress_difference)
      )
    end
    render json: goals, status: :ok
  end

  # Add to a goal to a goal(PATCH)
  def deposit
    if params[:amount].to_f.positive?
      @goal.progress || = 0
      @goal.progress += params[:amount].to_f

      if goal.save
        render json: {message 'Deposit added sucessfully🎉', progress: @goal.progress }, status: :ok
      else
        render json: {error: @goal.errors.full_messaes }, status: :unprocessable entity
      end
    else
      render json: {error: 'Amount must be positive'}, status: :unprocessable_entity
    end
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

  def status_message(difference)
    if difference.negative?
      "Goal is #{difference.abs} away from target."
    elsif difference.positive?
      "Goal surpassed by #{difference}!"
    else
      "Goal achieved exactly"
    end
  end
end
