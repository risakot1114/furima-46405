FactoryBot.define do
  factory :order_form do
    token { 'tok_abcdefghijk00000000000000000' }
    postal_code { '123-4567' }
    prefecture_id { 1 }
    city { '横浜市' }
    address { '青葉区1-1-1' }
    building { 'テストビル' }
    phone_number { '09012345678' }
  end
end
