require 'rails_helper'

RSpec.describe Api::V1::GoalsController, type: :controller do
  include Devise::Test::ControllerHelpers
  let(:user) { create(:user) }
  let!(:goals) do
    create_list(:goal, 3, user: user, amount: 1500.0, progress: 1000.0, start_date: Date.today, end_date: Date.today + 90.days)
  end
  
  let(:goal) { goals.first }

  before do
    sign_in user
  end

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
