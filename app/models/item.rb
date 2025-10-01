class Item < ApplicationRecord
  belongs_to :user

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category
  belongs_to :condition
  belongs_to :shipping_fee
  belongs_to :prefecture
  belongs_to :days_to_ship

  # ActiveStorageで画像を管理
  has_one_attached :image

  # 必須バリデーション
  validates :name, :description, :category_id, :condition_id,
            :shipping_fee_id, :prefecture_id, :days_to_ship_id, :price, :image, presence: true

  # 価格バリデーション
  validates :price, numericality: { only_integer: true, greater_than_or_equal_to: 300, less_than_or_equal_to: 9_999_999 }

  # 「---」が選ばれた場合を弾く
  validates :category_id, :condition_id, :shipping_fee_id, :prefecture_id, :days_to_ship_id, numericality: { other_than: 1 }
end
