class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # パスワードの半角英数字混合チェック
  validates :password, format: {
    with: /\A(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]+\z/,
    message: 'は半角英字と数字の両方を含めてください'
  }, if: -> { password.present? }

  # パスワード確認との一致はDeviseが自動でやってくれる
end
