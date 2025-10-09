class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item
  before_action :move_to_root
  before_action :set_locale

  def index
    @order_address = OrderAddress.new
  end

  def create
    @order_address = OrderAddress.new(order_params)
    if @order_address.valid?
      pay_item
      @order_address.save
      redirect_to root_path
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def set_item
    @item = Item.find(params[:item_id])
  end

  def move_to_root
    redirect_to root_path if current_user.id == @item.user_id || @item.order.present?
  end

  def order_params
    params.require(:order_address).permit(
      :postal_code, :prefecture_id, :city, :address, :building_name, :phone_number, :token
    ).merge(
      user_id: current_user.id,
      item_id: @item.id,
      token: params.dig(:order_address, :token)
    )
  end

  def pay_item
    return if Rails.env.test?

    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    Payjp::Charge.create(
      amount: @item.price,
      card: order_params[:token],
      currency: 'jpy'
    )
  end

  def set_locale
    I18n.locale = :ja if Rails.env.test?
  end
end
