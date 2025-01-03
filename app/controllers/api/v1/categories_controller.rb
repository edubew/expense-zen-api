class Api::V1::CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_category, only: %i[update destroy]

  # Create a category(POST)
  def create
    category = current_user.categories.new(category_params)
    if category.save
      render json: { message: 'Category created🎉' }, status: :created
    else
      render json: { error: 'Unable to create category😞' }, status: :unprocessable_entity
    end
  end

  # List all categories(GET)
  def index
    categories = current_user.categories
    render json: categories, status: :ok
  end

  # Edit a category(PUT)
  def update
    if @category.update(category_params)
      render json: @category, status: :ok
    else
      render json: { error: 'Could not update category😞Try again' }, status: :unprocessable_entity
    end
  end

  # Delete a category(DELETE)
  def destroy
    if @category.destroy
      render json: { message: 'Category removed successfully👌' }, status: :ok
    else
      render json: { message: 'Sorry, coud not remove category' }, status: :unprocessable_entity
    end
  end

  private

  def category_params
    params.require(:category).permit(:name, :icon)
  end

  def set_category
    @category = current_user.categories.find_by(id: params[:id])
    render json: { message: 'Category not found' }, status: :unprocessable_entity unless @category
  end
end
