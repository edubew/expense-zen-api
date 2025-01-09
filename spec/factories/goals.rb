FactoryBot.define do
  factory :goal do
    user
    name { 'Furniture Purchase' }
    amount { 4000.0 }
    progress { 800.0 }
    start_date { Date.today }
    end_date { Date.today + 120.days }
    status { 'Active'}
  end
end
