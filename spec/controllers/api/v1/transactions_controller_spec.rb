require 'rails_helper'

RSpec.describe Api::V1::TransactionsController, type: :controller do
  include Devise::Test::ControllerHelpers
  let(:user) { FactoryBot.create(:user) }
  let(:category) { FactoryBot.create(:category, user: user) }
  let(:valid_attributes) { { amount: 500.0, date: Date.today, item_name: 'Tomatoes' } }
  let(:invalid_attributes) { { amount: '', date: '', item_name: '' } }
  let!(:transaction) { FactoryBot.create(:transaction, category: category, user: user) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'returns a list of all transactions made' do
      get :index, params: { category_id: category.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to be_an_instance_of(Array)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new transaction' do
        expect do
          post :create, params: { category_id: category.id, transaction: valid_attributes }
        end.to change(Transaction, :count).by(1)
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['message']).to eq('Transaction created successfully🎉')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new transaction entry' do
        expect do
          post :create, params: { category_id: category.id, transaction: invalid_attributes }
        end.not_to change(Transaction, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Unable to create the transaction')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid attributes' do
      let(:new_attributes) { { amount: 1000.0 } }
      it 'updates the requested transaction entry' do
        put :update, params: { id: transaction.id, category_id: category.id, transaction: new_attributes }
        transaction.reload
        expect(transaction.amount).to eq(1000.0)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid attributes' do
      it 'does not update the transaction entry' do
        put :update, params: { id: transaction.id, category_id: category.id, transaction: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        errors = JSON.parse(response.body)['error']
        expected_errors = [
          "Amount can't be blank",
          'Amount is not a number',
          "Item name can't be blank",
          "Date can't be blank"
        ]
        expect(errors).to match_array(expected_errors)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroy the requested transaction entry' do
      expect do
        delete :destroy, params: { id: transaction.id, category_id: category.id }
      end.to change(Transaction, :count).by(-1)
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq('Transaction deleted successfully🎉')
    end
  end
end
