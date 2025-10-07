class Item < ApplicationRecord
  belongs_to :user
  has_one :order

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category
  belongs_to :condition
  belongs_to :shipping_fee
  belongs_to :prefecture
  belongs_to :days_to_ship

  has_one_attached :image
  has_one :order

  validates :name, :description, :category_id, :condition_id,
            :shipping_fee_id, :prefecture_id, :days_to_ship_id, :price, :image, presence: true

  validates :price, presence: true,
                    numericality: { only_integer: true, greater_than_or_equal_to: 300, less_than_or_equal_to: 9_999_999 }

  validates :category_id, :condition_id, :shipping_fee_id, :prefecture_id, :days_to_ship_id, numericality: { other_than: 0 }

  def sold_out?
    false # とりあえず全ての商品は未売却とする
  end

  def shipping_fee_status_i18n
    shipping_fee.name
  end
end
