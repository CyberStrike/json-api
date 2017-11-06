class ItemsController < ApplicationController

  before_action :set_todo

  def index
    render json: @todo.items
  end

  private

  def set_todo
    @todo = Todo.find(params[:todo_id])
  end
end
