class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :nickname, presence: true
  validates :first_name, :last_name, :first_name_kana, :last_name_kana, :birthday, presence: true

  validates :password,
            format: { with: /\A(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]+\z/,
                      message: 'は半角英字と数字の両方を含めてください' },
            if: -> { password.present? }

  # 1. first_name と last_name: ひらがな、カタカナ、漢字のみを許可
  # [ぁ-ん]:ひらがな, [ァ-ヶ]:カタカナ, [一-龥]:漢字, [々ー]:繰り返し記号・長音符
  validates :first_name, :last_name,
            format: { with: /\A[ぁ-んァ-ヶ一-龥々ー]+\z/,
                      message: 'はひらがな、カタカナ、漢字で入力してください' }

  # 2. first_name_kana と last_name_kana: 全角カタカナのみを許可
  # [ァ-ヶ]:カタカナ, [ー]:長音符
  validates :first_name_kana, :last_name_kana,
            format: { with: /\A[ァ-ヶー]+\z/,
                      message: 'は全角カタカナで入力してください' }

  has_many :items, dependent: :destroy
end
