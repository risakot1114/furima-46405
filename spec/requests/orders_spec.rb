require 'rails_helper'

RSpec.describe 'Orders', type: :request do
  before do
    @item = FactoryBot.create(:item)
    @user = FactoryBot.create(:user)
    @seller = @item.user
  end

  let(:order_params) do
    {
      order_address: {
        postal_code: '123-4567',
        prefecture_id: 2,
        city: '横浜市緑区',
        addresses: '青山1-1-1',
        building_name: '柳ビル103',
        phone_number: '09012345678',
        token: 'tok_abcdefghijk00000000000000000'
      }
    }
  end

  describe 'GET /items/:item_id/orders' do
    context 'ログインしているとき' do
      before { sign_in @user }

      it '他人の販売中商品なら購入ページへ遷移できる' do
        get item_orders_path(@item)
        expect(response).to have_http_status(:ok)
      end

      it '自分の出品商品ならトップページへリダイレクトされる' do
        sign_in @seller
        get item_orders_path(@item)
        expect(response).to redirect_to(root_path)
      end

      it '売却済み商品の購入ページへ行こうとするとトップページへリダイレクトされる' do
        FactoryBot.create(:order, item: @item, user: @user) # 売却済みにする
        get item_orders_path(@item)
        expect(response).to redirect_to(root_path)
      end
    end

    context 'ログインしていないとき' do
      it 'ログインページにリダイレクトされる' do
        get item_orders_path(@item)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST /items/:item_id/orders' do
    context 'ログインしているとき' do
      before { sign_in @user }

      it '正しい情報なら購入できてトップページへリダイレクトされる' do
        expect do
          post item_orders_path(@item), params: order_params
        end.to change { Order.count }.by(1)
                                     .and change { Address.count }.by(1)
        expect(response).to redirect_to(root_path)
      end

      it '情報が正しくないと購入ページに戻る' do
        post item_orders_path(@item), params: { order_address: { postal_code: '' } }
        expect(response).to have_http_status(422)
        # HTMLエスケープ済みのエラーメッセージを検証
        expect(response.body).to include('Postal code can&#39;t be blank')
      end

      it '情報に不備がある場合でも、カード情報以外の入力は保持される' do
        invalid_params = {
          order_address: {
            postal_code: '', # invalid to trigger errors
            prefecture_id: 2,
            city: '横浜市緑区',
            addresses: '青山1-1-1',
            building_name: '柳ビル103',
            phone_number: '09012345678',
            token: '' # blank token so card fields should be re-entered
          }
        }
        post item_orders_path(@item), params: invalid_params
        expect(response).to have_http_status(422)
        # 入力値保持（postal_code以外）
        expect(response.body).to include('横浜市緑区')
        expect(response.body).to include('青山1-1-1')
        expect(response.body).to include('柳ビル103')
        expect(response.body).to include('09012345678')
        # 郵便番号は空のまま
        expect(response.body).to include('id="postal-code"')
      end
    end

    context 'ログインしていないとき' do
      it '購入ページにアクセスできずログインページへ遷移する' do
        post item_orders_path(@item), params: order_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
