require 'rails_helper'

RSpec.describe Address, type: :model do
  before do
    user = FactoryBot.create(:user)
    item = FactoryBot.create(:item)
    order = FactoryBot.create(:order, user_id: user.id, item_id: item.id)
    @address = FactoryBot.build(:address, order_id: order.id)
  end

  context '保存できる場合' do
    it '必須項目がすべて揃っていれば保存できる' do
      expect(@address).to be_valid
    end
  end

  context '保存できない場合' do
    it 'postal_codeが空だと保存できない' do
      @address.postal_code = ''
      @address.valid?
      expect(@address.errors.full_messages).to include("Postal code can't be blank")
    end

    it 'postal_codeが「3桁-4桁」形式でないと保存できない' do
      @address.postal_code = '1234567'
      @address.valid?
      expect(@address.errors.full_messages).to include('Postal code は「3桁-4桁」で入力してください')
    end

    it 'phone_numberが空だと保存できない' do
      @address.phone_number = ''
      @address.valid?
      expect(@address.errors.full_messages).to include("Phone number can't be blank")
    end

    it 'phone_numberが10桁未満、または11桁超だと保存できない' do
      @address.phone_number = '123456789'
      @address.valid?
      expect(@address.errors.full_messages).to include('Phone number は10〜11桁で入力してください')

      @address.phone_number = '123456789012'
      @address.valid?
      expect(@address.errors.full_messages).to include('Phone number は10〜11桁で入力してください')
    end

    it 'phone_numberにハイフンがあると保存できない' do
      @address.phone_number = '090-1234-5678'
      @address.valid?
      expect(@address.errors.full_messages).to include('Phone number は10〜11桁で入力してください')
    end
  end
end
