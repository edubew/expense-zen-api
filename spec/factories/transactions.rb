FactoryBot.define do
  factory :transaction do
    amount { 500.0 }
    date { Date.today }
    item_name { 'Tomatoes' }
    association :category
    association :user
  end
end