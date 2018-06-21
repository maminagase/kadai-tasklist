class TasksController < ApplicationController
before_action :require_user_logged_in
before_action :correct_user, only: [:destroy, :edit, :show]

    def index
        if logged_in?
        @user = current_user
        @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
        end
    end

    def show
        @task = Task.find(params[:id])
    end

    def new
        @task = Task.new
    end

    def create
        @task = current_user.tasks.build(task_params)
     
        if @task.save
            flash[:success] = "投稿されました"
            redirect_to @task
        else
            @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
            flash.now[:denger] = "投稿されませんでした"
            render :new
        end
    end

    def edit
        @task = Task.find(params[:id])
    end

    def update
        @task = Task.find(params[:id])
        
        @task = current_user.tasks.build(task_params)
        if @task.update(task_params)
            flash[:success] = "更新されました"
            redirect_to @task
        else
            flash.now[:denger] = "更新されませんでした"
            render :edit
        end
        
    end

    def destroy
        @task.destroy
        flash[:success] = '削除しました。'
        redirect_to @task
    end
    
    private
    
    def task_params
        params.require(:task).permit(:content, :status)
    end
    
    def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
    

end
  
