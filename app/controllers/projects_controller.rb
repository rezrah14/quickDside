class ProjectsController < ApplicationController

  before_action :get_project, only: [:show, :edit, :update, :destroy]

  def show
    @users = @project.users
  end

  def index
    @projects = Project.paginate(page: params[:page], per_page: 5)
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      flash[:notice] = "Project was created successfully."
      redirect_to @project
      # ^ is the shortened version of : redirect_to project_path(@project.id)
    else
      render 'new', status: :unprocessable_entity
    end
    
  end

  def edit
  end

  def update
    if @project.update(project_params)
      flash[:notice] = "Project was editted successfully."
      redirect_to @project
      # ^ is the shortened version of : redirect_to project_path(@project.id)
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path
  end

  private

  def get_project
    id = params[:id]
    if Project.exists?(id)
      @project = Project.find(id)
    end
  end

  def project_params
    params.require(:project).permit(:title, :description)
  end


end