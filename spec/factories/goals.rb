FactoryBot.define do
  factory :goal do
    user
    name { 'Furniture Purchase' }
    amount { 40_000.0 }
    start_date { Date.today }
    end_date { Date.today + 120.days }
    progress { 0.0 }
  end
end
