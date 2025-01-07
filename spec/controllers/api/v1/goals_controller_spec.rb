# require 'swagger_helper'
require 'rails_helper'

# RSpec.describe Api::V1::GoalsController, type: :controller do
#   include Devise::Test::ControllerHelpers

# RSpec.describe 'Goals API', type: :request do
  let(:user) { create(:user) }
  let!(:goals) do
    create_list(:goal, 3, user: user, amount: 1500.0, progress: 1000.0, start_date: Date.today, end_date: Date.today + 90.days)
  end
  
  let(:goal) { goals.first }

  before do
    sign_in user
  end

  # describe 'GET #index' do
  #   it 'lists all goals for the current user' do
  #     get :index
  #     expect(response).to have_http_status(:ok)
  #     response_body = JSON.parse(response.body)
  #     expect(response_body.size).to eq(3)
  #     expect(response_body.first).to include('progress_difference', 'status')
  #   end
  # end
  # path '/goals' do
  #   post 'Create a new goal' do
  #     tags 'Goals'
  #     consumes 'application/json'
  #     parameter name: :goal, in: :body, schema: {
  #       type: :object,
  #       properties: {
  #         amount: { type: :number },
  #         name: { type: :string },
  #         start_date: { type: :string, format: :date },
  #         end_date: { type: :string, format: :date }
  #       },
  #       required: %w[amount name start_date end_date]
  #     }

  #     response '201', 'Goal created successfully' do
  #       let(:goal) { { amount: 1000.0, name: 'Furniture', start_date: Date.today.to_s, end_date: (Date.today + 120.days).to_s } }
  #       run_test!
  #     end

  #     response '422', 'Invalid parameters' do
  #       let(:goal) {{ amount: nil, name: '', start_date: nil, end_date: nil}}
  #       run_test!
  #     end
  #   end
  # end

  # path '/goals/{id}/deposit' do
  #   patch 'Add progress to the goal' do
  #     tags 'Goals'
  #     consumes 'application/json'
  #     parameter name: :id, in: :path, type: :string, description: 'Goal ID'
  #     parameter name: :amount, in: :body, schema: {
  #       type: :object,
  #       properties: {
  #         amount: { type: :number }
  #       },
  #       required: ['amount']
  #     }

  #     response '200', 'Progress added successfully' do
  #       let(:id) { goal.id }
  #       let(:amount) {{ amount: 200.0 }}
  #       run_test!
  #     end

  #     response '404', 'Goal not found' do
  #       let(:id) {-1}
  #       let(:amount){{ amount: 200.0 }}
  #       run_test!
  #     end 
  #   end
  # end

  # path 'goals/' do
  #   get 'List all user\'s goals' do
  #     tags 'Goals'
  #     produces 'application/json'

  #     response '200', 'Goals listed successfully' do
  #       schema type: :array, items: {
  #         type: :object,
  #         properties: {
  #           id: {type: :integer },
  #           amount: { type: :number},
  #           progress: { type: :number },
  #           progress_difference: { type: :number },
  #           status: {type: :string},
  #           start_date: {type: :string, format: :date },
  #           end_date: { type: :string, format: :date }
  #         },
  #         required: %w[id amount progress progress_difference status start_date end_date]
  #       }
  #       run_test!
  #     end
  #   end
  # end

  # path '/goals/{id}' do
  #   get 'Retrieve goal details' do
  #     tags 'Goals'
  #     produces 'application/json'
  #     parameter name: :id, in: :path, type: :string, description: 'Goal ID'

  #     response '200', 'Goal details retrieved successfully' do
  #       let(:id) { goal.id }
  #       run_test!
  #     end

  #     response '404', 'Goal not found' do
  #       let(:id) {-1}
  #       run_test!
  #     end
  #   end

  #   delete 'Delete a goal' do
  #     tags 'Goals'
  #     produces 'application/json'
  #     parameter name: :id, in: :path, type: :string, description: 'Goal ID'

  #     response '200', 'Goal deleted successfully' do
  #       let(:id) {goal.id}
  #       run_test!
  #     end

  #     response '404', 'Goal not found' do
  #       let(:id) {-1}
  #       run_test!
  #     end
  #   end
  # end

  describe 'POST #create' do
    it 'creates a new goal' do
      post :create,
           params: { goal: { amount: 1000.0, name: 'Furniture', start_date: Date.today,
                             end_date: Date.today + 120.days } }
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['message']).to eq('Goal created successfully🎉')
    end
  end

   describe 'GET #index' do
    it 'lists all goals for the current user' do
      get :index
      expect(response).to have_http_status(:ok)
      response_body = JSON.parse(response.body)
      expect(response_body.size).to eq(3)
      expect(response_body.first).to include('progress_difference', 'status')
    end
  end

  describe 'PATCH #deposit' do
    it 'adds progress to the goal' do
      patch :deposit, params: { id: goal.id, amount: 200.0 }
      expect(response).to have_http_status(:ok)
      updated_goal = Goal.find(goal.id)
      expect(updated_goal.progress.to_f).to eq(1200.0)
      expect(updated_goal.status).to eq('Active')
    end
  end

  describe 'GET #show' do
    it 'shows goal details and progress' do
      get :show, params: { id: goal.id }
      expect(response).to have_http_status(:ok)
      response_body = JSON.parse(response.body)
      expect(response_body['goal']['progress'].to_f).to eq(1000.0)
      expect(response_body['status_message']).to eq('You are actively working on this goal. Keep it up!🚀')
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes a goal' do
      delete :destroy, params: { id: goal.id }
      expect(response).to have_http_status(:ok)
      expect { Goal.find(goal.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
