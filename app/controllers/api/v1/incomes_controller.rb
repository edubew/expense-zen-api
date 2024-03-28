class Api::V1::IncomesController < ApplicationController
  before_action :authenticate_user
  before_action :set_income, only: [:update, :destroy]

  # Create a new income entry(POST)
  def create
    income = current_user.incomes.new(income_params)
    if income.save
      render json: { message: 'Income entry created successfully🎉' }, status: :created
    else
      render json: { error: 'Unable to create entry' }, status: :unprocessable_entity
    end
  end

  # List all income entries(GET)
  def index
    incomes = current_user.incomes
    render json: incomes, status: :ok
  end

  # Edit an existing entry(PUT)
  def update
    if @income.update(income_params)
      render json: { message: 'Income updated successfully🎉' }, status: :ok
    else
      render json: { error: @income.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Delete an Income entry(DELETE)
  def destroy
    if @income.destroy
      render json: { message: 'Income entry deleted successfully🎉' }, status: :ok
    else
      render json: { error: 'Unable to delete income entry' }, status: :unprocessable_entity
    end
  end

  private

  def income_params
    params.require(:income).permit(:amount, :date, :source)
  end

  def set_income
    @income = current_user.incomes.find(params[:id])
  end
end
