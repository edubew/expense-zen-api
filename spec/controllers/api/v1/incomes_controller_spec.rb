require 'rails_helper'

RSpec.describe Api::V1::IncomesController, type: :controller do
  include Devise::Test::ControllerHelpers
  let(:user) { FactoryBot.create(:user) }
  let(:valid_attributes) { { amount: 1000.0, date: Date.today, source: 'Freelance' } }
  let(:invalid_attributes) { { amount: '', date: '', source: '' } }
  let!(:income) { FactoryBot.create(:income, user: user) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'returns a list of all income entries' do
      get :index
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to be_an_instance_of(Array)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new income entry' do
        expect do
          post :create, params: { income: valid_attributes }
        end.to change(Income, :count).by(1)
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['message']).to eq('Income entry created successfully🎉')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new income entry' do
        expect do
          post :create, params: { income: invalid_attributes }
        end.not_to change(Income, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Unable to create entry')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid parameters' do
      let(:new_attributes) { { amount: 2000.0 } }
      it 'updates the requested income entry' do
        put :update, params: { id: income.id, income: new_attributes }
        income.reload
        expect(income.amount).to eq(2000.0)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  context 'with invalid parameters' do
    it 'does not update the income entry' do
      put :update, params: { id: income.id, income: invalid_attributes }
      expect(response).to have_http_status(:unprocessable_entity)
      errors = JSON.parse(response.body)['error']
      expected_errors = [
        "Amount can't be blank",
        'Amount is not a number',
        "Source can't be blank",
        "Date can't be blank"
      ]
      expect(errors).to match_array(expected_errors)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested income entity' do
      expect do
        delete :destroy, params: { id: income.id }
      end.to change(Income, :count).by(-1)
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq('Income entry deleted successfully🎉')
    end

    it 'does not destroy a non-existent income entry' do
      expect do
        delete :destroy, params: { id: -1 }
      end.not_to change(Income, :count)
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
