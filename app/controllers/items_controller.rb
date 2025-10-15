class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_item, only: [:edit, :update, :show, :destroy]
  before_action :move_to_root_unless_owner, only: [:edit, :update, :destroy]
  before_action :redirect_if_sold_out, only: [:edit, :update]

  def index
    @items = Item.order(created_at: :desc)
  end

  def new
    @item = Item.new
  end

  def create
    @item = current_user.items.new(item_params)
    if @item.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    gon.public_key = ENV['PAYJP_PUBLIC_KEY']
  end

  def edit
  end

  def update
    if @item.update(item_params)
      redirect_to @item
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy
    redirect_to root_path
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def move_to_root_unless_owner
    redirect_to root_path unless current_user == @item.user
  end

  def redirect_if_sold_out
    redirect_to root_path if @item.sold_out?
  end

  def item_params
    params.require(:item).permit(
      :name, :description, :category_id, :condition_id,
      :shipping_fee_id, :prefecture_id, :days_to_ship_id, :price, :image
    )
  end
end
