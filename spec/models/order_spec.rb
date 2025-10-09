require 'rails_helper'

RSpec.describe Order, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @item = FactoryBot.create(:item)
    @order = FactoryBot.build(:order, user_id: @user.id, item_id: @item.id)
  end

  it 'user_idとitem_idがあれば保存できる' do
    expect(@order).to be_valid
  end

  it 'user_idがなければ保存できない' do
    @order.user_id = nil
    @order.valid?
    expect(@order.errors.full_messages).to include('User must exist')
  end

  it 'item_idがなければ保存できない' do
    @order.item_id = nil
    @order.valid?
    expect(@order.errors.full_messages).to include('Item must exist')
  end
end
