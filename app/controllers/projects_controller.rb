class ProjectsController < ApplicationController

  def show
    id = params[:id]
    if Project.exists?(id)
      @project = Project.find(id)
    else
      @project = Project.new
    end
  end

  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(params.require(:project).permit(:title, :description))
    if @project.save
      flash[:notice] = "Project was created successfully."
      redirect_to @project
      # ^ is the shortened version of : redirect_to project_path(@project.id)
    else
      render 'new', status: :unprocessable_entity
    end
    
  end

  def edit
    id = params[:id]
    if Project.exists?(id)
      @project = Project.find(id)
    end
  end

  def update
    @project = Project.find(params[:id])
    if @project.update(params.require(:project).permit(:title, :description))
      flash[:notice] = "Project was editted successfully."
      redirect_to @project
      # ^ is the shortened version of : redirect_to project_path(@project.id)
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    id = params[:id]
    if Project.exists?(id)
      @project = Project.find(id)
      @project.destroy
      redirect_to projects_path
    end
  end

end