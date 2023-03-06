class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  def index
    if params[:user_id]
      items = user_find.items
    else
      items = Item.all
    end

    render json: items, include: :user
  end

  def show
    render json: item_find
  end

  def create
    item = user_find.items.create(item_params)
    render json: item, status: :created
  end

  private

  def user_find
    User.find(params[:user_id])
  end

  def item_find
    Item.find(params[:id])
  end

  def item_params
    params.permit(:name, :description, :price)
  end

  def render_not_found(exception)
    render json: {error: "#{exception.model} not found"}, status: :not_found
  end

end
