class TasksController < ApplicationController

  def index
    per_page = params[:per_page] || Kaminari.config.default_per_page
    @tasks = Task.where(deleted_at: nil).page(params[:page]).per(per_page)
    render 'api/tasks/index'
  end

  def searchby_tag
    @tag = params[:tag]
    @tasks = Task.where(tags: @tag)
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

    if @task.soft_delete

      render json: { status: 'Deleted', message: 'Task was successfully soft-deleted' }, status: :ok
    else
     
      render json: { status: 'Error', message: 'Failed to soft-delete the task', errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def restore
    @task = Task.unscoped.find(params[:id])

    if @task.restore

      render json: { status: 'Restored', message: 'Task was successfully restored' }, status: :ok
    else
      
      render json: { status: 'Error', message: 'Failed to restore the task', errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
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
    params.require(:task).permit(:title, :description, tags: []).merge(status: params[:status])
  end

end
