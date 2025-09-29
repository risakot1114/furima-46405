FactoryBot.define do
  factory :user do
    nickname { '山田太郎' }
    email { 'yamada@example.com' }
    password { 'abc123' }
    password_confirmation { password }
    first_name { '太郎' }
    last_name { '山田' }
    first_name_kana { 'タロウ' }
    last_name_kana { 'ヤマダ' }
    birthday { '1990-01-01' }
  end
end
