require 'rails_helper'

RSpec.describe 'Items', type: :request do
  let(:seller) { FactoryBot.create(:user) }
  let(:buyer)  { FactoryBot.create(:user) }
  let(:item)   { FactoryBot.create(:item, user: seller) }

  describe 'Sold out表示とボタン制御' do
    context '一覧/詳細の表示' do
      it '売却済み商品の画像上にSold Out!!が表示される（一覧）' do
        FactoryBot.create(:order, item: item, user: buyer)
        get items_path
        expect(response.body).to include('Sold Out!!')
      end

      it '売却済み商品の画像上にSold Out!!が表示される（詳細）' do
        FactoryBot.create(:order, item: item, user: buyer)
        get item_path(item)
        expect(response.body).to include('Sold Out!!')
      end
    end

    context '詳細ページのボタン表示' do
      it '売却済みの場合、購入ボタンが表示されない（他人）' do
        FactoryBot.create(:order, item: item, user: buyer)
        sign_in buyer
        get item_path(item)
        expect(response.body).not_to include('購入画面に進む')
      end

      it '売却済みの場合、自身の商品でも編集/削除ボタンが表示されない' do
        FactoryBot.create(:order, item: item, user: buyer)
        sign_in seller
        get item_path(item)
        expect(response.body).not_to include('商品の編集')
        expect(response.body).not_to include('削除')
      end
    end

    context '編集ページへの遷移制御' do
      it '自身の売却済み商品編集ページへアクセスするとトップにリダイレクト' do
        FactoryBot.create(:order, item: item, user: buyer)
        sign_in seller
        get edit_item_path(item)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
