class OrderForm
  include ActiveModel::Model

  # フォームで扱う属性
  attr_accessor :user_id, :item_id, :token,
                :postal_code, :prefecture_id, :city, :address, :building, :phone_number

  # バリデーション
  with_options presence: true do
    validates :user_id
    validates :item_id
    validates :token
    validates :postal_code, format: { with: /\A\d{3}-\d{4}\z/, message: "は'123-4567'のように入力してください" }
    validates :prefecture_id, numericality: { other_than: 0, message: 'を選択してください' }
    validates :city
    validates :address
    validates :phone_number, format: { with: /\A\d{10,11}\z/, message: 'は10〜11桁の数字で入力してください' }
  end

  # 保存処理
  def save
    return false unless valid?

    # Order と Address に分けて保存
    order = Order.create(user_id: user_id, item_id: item_id)
    Address.create(
      order_id: order.id,
      postal_code: postal_code,
      prefecture_id: prefecture_id,
      city: city,
      address: address,
      building: building,
      phone_number: phone_number
    )
  end
end
