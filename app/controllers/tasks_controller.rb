class TasksController < ApplicationController

  def index
    per_page = params[:per_page] || Kaminari.config.default_per_page
    @tasks = Task.page(params[:page])
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

   @task.destroy

  end
  def restore
    @task = Task.unscoped.find(params[:id])
    respond_to do |format|
      Rails.logger.debug
      if @task.restore
        format.html { redirect_to @task, notice: 'Todo item was successfully restored.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # def restore
  #   @task=Task.unscoped.find(params[:id])
  #   # @task = Task.only_deleted.
  #   respond_to do |format|
  #     if @task.restore
  #        format.json { render :show, status: :ok, location: @task }
  #     else

  #       format.json { render json: @task.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
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
