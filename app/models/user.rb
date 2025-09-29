class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :nickname, presence: true
  validates :first_name, :last_name, :first_name_kana, :last_name_kana, :birthday, presence: true

  validates :password, presence: true,
                       length: { minimum: 6, message: 'は6文字以上で入力してください' },
                       format: { with: /\A(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]+\z/,
                                 message: 'は半角英字と数字の両方を含めてください' },
                       if: -> { password.present? }
end
