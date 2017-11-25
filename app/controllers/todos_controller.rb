class TodosController < ApplicationController
  before_action :set_todo, only: [:show, :update, :destroy]

  # GET /todos
  def index
    @todos = @current_user.todos.all
    render json: @todos
  end

  # GET /todos/1
  def show
    render json: @todo
  end

  # POST /todos
  def create
    # Purposely passing the test in the wrong way here.
    @todo = @current_user.todos.new( todo_params )

    if @todo.save
      render json: @todo, status: :created, location: @todo
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /todos/1
  def update
    if @todo.update(todo_params)
      render json: @todo
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  # DELETE /todos/1
  def destroy
    if @todo.destroy
      render status: :gone
    else
      render json: @todo.errors, status: :not_found
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_todo
      @todo = @current_user.todos.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def todo_params
      params.require(:todo).permit(:title, :created_by)
    end
end
