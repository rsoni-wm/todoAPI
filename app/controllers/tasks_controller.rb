class TasksController < ApplicationController
  def index
    @tasks = Task.all
    render 'api/tasks/index'
  end

  def show
    @task = Task.find(params[:id])
    render 'api/tasks/show'
  end
  def create
    @task = Task.new(task_params)

    if @task.save
      render 'api/tasks/show', status: :created
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end
  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    head :no_content
  end
  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      render 'api/tasks/show'
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end


  private

  def task_params
    params.require(:task).permit(:title, :description, :status)
  end

end
