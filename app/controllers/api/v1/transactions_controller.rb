class Api::V1::TransactionsController < ApplicationController
  before_action :authenticate_user
  before_action :set_category
  before_action :set_transaction, only: [:show, :update, :destroy]

  # Create a new transaaction(POST)
  def create
    transaction = @category.transactions.new(transaction_params)
    if transaaction.save
      render json: { message: 'Transaction created successfully🎉' }, status: :created
    else
      render json: { error: 'Unable to create the transaction' }, status: :unprocessable_entity
    end
  end

  # List all transactions(GET)
  def index
    transactions = @category.transactions.order(created_at: :desc)
    render json: transactions, status: :ok
  end

  # Show details of a specific transaction
  def show
    render json: @transaction, status: :ok
  end

  # Edit an existing transaction(PUT)
  def update
    if @transaction.update(transaction_params)
      render json: { message: 'Transaction updated successfully🎉' }, status: :ok
    else
      render json: { error: @transaction.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Delete a transaction(DELETE)
  def destroy
    if @transaction.destroy
      render json: { message: 'Transaction deleted successfully🎉' }, status: :ok
    else
      render json: { error: 'Unable to delete the transaction' }, status: :unprocessable_entity
    end
  end


  private


  def transaction_params
    params.require(:transaction).permit(:amount, :date, :description)
  end

  def set_category
    @category = current_user.categories.find(params[:category_id])
  end

  def set_transaction
    @transaction = @category.transactions.find(params[:id])
  end
end
