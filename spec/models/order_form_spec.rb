require 'rails_helper'

RSpec.describe OrderForm, type: :model do
  before do
    user = FactoryBot.create(:user)
    item = FactoryBot.create(:item)
    @order_form = FactoryBot.build(:order_form, user_id: user.id, item_id: item.id)
  end

  describe '商品購入機能' do
    context '購入できるとき' do
      it 'すべての値が正しく入力されていれば購入できる' do
        expect(@order_form).to be_valid
      end
    end

    context '購入できないとき' do
      it 'tokenが空では購入できない' do
        @order_form.token = ''
        @order_form.valid?
        expect(@order_form.errors.full_messages).to include("Token can't be blank")
      end

      it 'postal_codeが空では購入できない' do
        @order_form.postal_code = ''
        @order_form.valid?
        expect(@order_form.errors.full_messages).to include("Postal code can't be blank")
      end
    end
  end
end
