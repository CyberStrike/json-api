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

    if @item.save
      render json: @item, status: :created
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  def update
    if @item.update(item_params)
      render json: @item
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @item.destroy
      render status: :gone
    else
      render json: @item.errors, status: :not_found
    end
  end

  private

  def item_params
    params.permit(:name, :done)
  end

  def set_todo

    # Not sure if code or security smell
    # I have feeling that if I dump the memory I will see the record
    # regardless of the user check. Maybe better to not load it at all?
    # @todo = @current_user.todos.find(params[:todo_id])
    #
    todo = Todo.find(params[:todo_id])
    if todo.user == @current_user
      @todo = todo
    else
      raise ExceptionHandler::AuthenticationError, I18n.t(:unauthorized)
    end
  end

  def set_todo_item
    @item = @todo.items.find_by!(id: params[:id]) if @todo
  end

end
