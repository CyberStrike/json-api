class ItemsController < ApplicationController

  before_action :set_todo
  before_action :set_todo_item, except: [:index, :create]

  def index
    render json: @todo.items
  end

  def show
    render json: @item
  end

  def create
    @item = @todo.items.new(item_params)
    render json: @item, status: :created if @item.save
  end

  private
  def item_params
    params.permit(:name, :done)
  end

  def set_todo
    @todo = Todo.find(params[:todo_id])
  end

  def set_todo_item
    @item = @todo.items.find_by!(id: params[:id]) if @todo
  end

end
