class OrderAddress
  include ActiveModel::Model
  attr_accessor :postal_code, :prefecture_id, :city, :addresses, :building_name,
                :phone_number, :user_id, :item_id, :token

  alias_attribute :address, :addresses

  validates :token, presence: true
  validates :postal_code, presence: true
  validates :postal_code, format: { with: /\A\d{3}-\d{4}\z/, message: 'is invalid. Enter it as follows (e.g. 123-4567)' },
                          allow_blank: true
  validates :prefecture_id, presence: true, numericality: { other_than: 1 }
  validates :city, presence: true
  validates :addresses, presence: true
  validates :phone_number, presence: true
  validates :phone_number, format: { with: /\A\d+\z/, message: 'is invalid. Input only number' }, allow_blank: true
  validates :phone_number, length: { minimum: 10, maximum: 11, too_short: 'is too short' }, allow_blank: true
  validates :user_id, presence: true
  validates :item_id, presence: true

  def save
    order = Order.create(user_id: user_id, item_id: item_id)
    Address.create(
      postal_code: postal_code,
      prefecture_id: prefecture_id,
      city: city,
      address: addresses,
      building_name: building_name,
      phone_number: phone_number,
      order_id: order.id
    )
  end
end
