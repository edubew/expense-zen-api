require 'rails_helper'

RSpec.describe Api::V1::CategoriesController, type: :controller do
  include Devise::Test::ControllerHelpers
  let(:user) { FactoryBot.create(:user) }
  let(:valid_attributes) { { name: 'Test Category', icon: 'test-icon' } }
  let(:invalid_attributes) { { name: '', icon: '' } }
  let!(:category) { FactoryBot.create(:category, user: user) }
  
  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'returns a list of categories' do
      get :index
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to be_an_instance_of(Array)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new category' do
        expect {
          post :create, params: { category: valid_attributes }
        }.to change(Category, :count).by(1)
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['message']).to eq('Category created🎉')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new category' do
        expect {
          post :create, params: { category: invalid_attributes }
        }.not_to change(Category, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Unable to create category😞')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid parameters' do
      let(:new_attributes) { { name: 'Updated Category' } }

      it 'updates the requested category' do
        put :update, params: { id: category.id, category: new_attributes }
        category.reload
        expect(category.name).to eq('Updated Category')
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid parameters' do
      it 'does not update the category' do
        put :update, params: { id: category.id, category: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Could not update category😞Try again')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested category' do
      expect {
        delete :destroy, params: { id: category.id }
      }.to change(Category, :count).by(-1)
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq('Category removed successfully👌')
    end

    it 'does not destroy a non-existent category' do
      expect {
        delete :destroy, params: { id: -1 }
      }.not_to change(Category, :count)
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end