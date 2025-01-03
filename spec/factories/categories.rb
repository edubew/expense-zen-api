FactoryBot.define do
  factory :category do
    name { 'Test Category' }
    icon { 'test-icon' }
    association :user
  end
end
