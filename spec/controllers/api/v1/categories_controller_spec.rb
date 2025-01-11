require 'swagger_helper'
require 'rails_helper'

RSpec.describe 'Categories API', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:valid_attributes) { { name: 'Test Category', icon: 'test-icon' } }
  let(:invalid_attributes) { { name: '', icon: '' } }
  let!(:category) { FactoryBot.create(:category, user: user) }

  before do
    sign_in user
  end

  path '/api/v1/categories' do
    get 'Retrieve all categories' do
      tags 'Categories'
      produces 'application/json'
      security [bearer_auth: []]

      response '200', 'categories retrieved' do
        run_test! do |response|
          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)).to be_an_instance_of(Array)
        end
      end
    end

    post 'Create a new category' do
      tags 'Categories'
      consumes 'application/json'
      security [bearer_auth: []]
      parameter name: :category, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          icon: { type: :string }
        },
        required: %w[name icon]
      }

      response '201', 'category created' do
        let(:params) { { category: valid_attributes } }
        run_test! do |response|
          expect(response).to have_http_status(:created)
          expect(JSON.parse(response.body)['message']).to eq('Category created🎉')
        end
      end

      response '422', 'invalid parameters' do
        let(:params) { { category: invalid_attributes } }
        run_test! do |response|
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)['errors']).to include("Name can't be blank", "Icon can't be blank")
        end
      end
    end
  end

  path '/api/v1/categories/{id}' do
    put 'Update a category' do
      tags 'Categories'
      consumes 'application/json'
      security [bearer_auth: []]
      parameter name: :id, in: :path, type: :integer, description: 'Category ID'
      parameter name: :category, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          icon: { type: :string }
        },
        required: %w[name icon]
      }

      response '200', 'category updated' do
        let(:id) { category.id }
        let(:params) { { category: { name: 'Updated Category', icon: 'updated-icon' } } }
        run_test! do |response|
          expect(response).to have_http_status(:ok)
          category.reload
          expect(category.name).to eq('Updated Category')
        end
      end

      response '422', 'invalid parameters' do
        let(:id) { category.id }
        let(:params) { { category: invalid_attributes } }
        run_test! do |response|
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)['error']).to eq('Could not update category😞 Try again')
        end
      end
    end

    delete 'Delete a category' do
      tags 'Categories'
      security [bearer_auth: []]
      parameter name: :id, in: :path, type: :integer, description: 'Category ID'

      response '200', 'category deleted' do
        let(:id) { category.id }
        run_test! do |response|
          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)['message']).to eq('Category removed successfully👌')
        end
      end

      response '422', 'invalid request' do
        let(:id) { -1 }
        run_test! do |response|
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end
end
