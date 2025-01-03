FactoryBot.define do
  factory :income do
    amount { 1000.0 }
    date { Date.today }
    source { 'Freelance' }
    association :user
  end
end
