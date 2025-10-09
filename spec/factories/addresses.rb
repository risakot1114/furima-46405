FactoryBot.define do
  factory :address do
    postal_code { '123-4567' }
    prefecture_id { 2 }
    city { '横浜市青葉区' }
    address { '1-1-1' }
    building_name { 'マンション101' }
    phone_number { '09012345678' }
    association :order
  end
end
