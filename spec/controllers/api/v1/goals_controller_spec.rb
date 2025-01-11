require 'swagger_helper'
require 'rails_helper'

RSpec.describe 'Goals API', type: :request do
  include Devise::Test::IntegrationHelpers
let(:user) { create(:user) }
let!(:goals) do
  create_list(:goal, 3, user: user, amount: 1500.0, progress: 1000.0, start_date: Date.today,
                        end_date: Date.today + 90.days)
end

let(:goal) { goals.first }

before do
  sign_in user
end

path '/api/v1/goals/' do
  get 'List all goals for the current user' do
    tags 'Goals'
    produces 'application/json'
    security [bearer_auth: []]

    response '200', 'Goals listed successfully' do
      schema type: :array,
      items: {
        type: :object,
        properties: {
          id: {type: :integer },
          amount: { type: :number, format: :float, description: 'Target amount for the goal' },
          progress: { type: :number, format: :float, description: 'Current progress towards the goal' },
          progress_difference: { type: :number, format: :float, description: 'Remaining progress needed' },
          status_message: {type: :string, description: 'Dynamic message indicating goal status'},
          start_date: {type: :string, format: :date },
          end_date: { type: :string, format: :date }
        },
        required: %w[id amount progress progress_difference status_message start_date end_date]
      }
      run_test! do |response|
        data = JSON.parse(response.body)
        expect(data.size).to eq(3)
        expect(data.first['progress_difference']).to eq(data.first['amount'] - data.first['progress'])
        expect(data.first['status_message']).to be_present
        puts JSON.pretty_generate(JSON.parse(response.body))

      end
    end

    response '401', 'Unauthorized' do
      let(:Authorization) {nil}
      run_test!
    end
  end
end

path '/api/v1/goals' do
  post 'Create a new goal' do
    tags 'Goals'
    consumes 'application/json'
    parameter name: :goal, in: :body, schema: {
      type: :object,
      properties: {
        amount: { type: :number, format: :float, description: 'Target amount for the goal' },
        name: { type: :string },
        start_date: { type: :string, format: :date },
        end_date: { type: :string, format: :date }
      },
      required: %w[amount name start_date end_date]
    }

    response '201', 'Goal created successfully' do
      let(:goal) {
  { amount: 1000.0, name: 'Furniture', start_date: Date.today.to_s, end_date: (Date.today + 120.days).to_s }
}
      run_test!
    end

    response '422', 'Invalid parameters' do
      let(:goal) {{ amount: nil, name: '', start_date: nil, end_date: nil}}
      run_test!
    end
  end
end

path '/api/v1/goals/{id}/deposit' do
  patch 'Add progress to the goal' do
    tags 'Goals'
    consumes 'application/json'
    parameter name: :id, in: :path, type: :string, description: 'Goal ID'
    parameter name: :amount, in: :body, schema: {
      type: :object,
      properties: {
        amount: { type: :number, format: :float }
      },
      required: ['amount']
    }

    response '200', 'Progress added successfully' do
      let(:id) { goal.id }
      let(:amount) {{ amount: 200.0 }}
      run_test!
    end

    response '404', 'Goal not found' do
      let(:id) {-1}
      let(:amount){{ amount: 200.0 }}
      run_test!
    end
  end
end

path '/api/v1/goals/{id}' do
  get 'Retrieve goal details' do
    tags 'Goals'
    produces 'application/json'
    parameter name: :id, in: :path, type: :string, description: 'Goal ID'

    response '200', 'Goal details retrieved successfully' do
      let(:id) { goal.id }
      run_test!
    end

    response '404', 'Goal not found' do
      let(:id) {-1}
      run_test!
    end
  end

  delete 'Delete a goal' do
    tags 'Goals'
    produces 'application/json'
    parameter name: :id, in: :path, type: :string, description: 'Goal ID'

    response '200', 'Goal deleted successfully' do
      let(:id) {goal.id}
      run_test!
    end

    response '404', 'Goal not found' do
      let(:id) {-1}
      run_test!
    end
  end
end
end
