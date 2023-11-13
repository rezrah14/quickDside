class ProjectsController < ApplicationController

  before_action :get_project, only: [:show, :edit, :update, :destroy]
  # before_action :require_included_user
  before_action :require_admin_user, only: [:edit, :update]
  before_action :require_owner_user, only: [:destroy]

  def show
    @users = @project.all_users
    @components = @project.components
  end

  def index
    @projects = current_user.all_projects.paginate(page: params[:page], per_page: 5)
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.owner = current_user
    @project.start_date = Date.parse(project_params[:start_date])
    if @project.save
      # Add the current user as an owner in the ProjectUser model
      @project_user = ProjectUser.create(user: current_user, project: @project, access_level: ProjectUser.access_levels[:owner])
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

  def destroy
    if @project.owner == current_user
      @project.destroy
      redirect_to projects_path
    else
      flash[:alert] = "You can only edit or delete your own project"
    end
  end

  private

  def get_project
    id = params[:id]
    if Project.exists?(id)
      @project = Project.find(id)
    end
  end

  def project_params
    params.require(:project).permit(:title, :description, :start_date, :length, :monthly_resolution_end_year)
                             .transform_values { |value| value.presence || nil }
  end
  

  def require_included_user
    if !@project.all_users.include?(current_user)
      flash[:alert] = "You do not have access to this project"
      redirect_to projects_path
    end
  end

  def require_admin_user
    unless @project.admins.include?(current_user) || @project.owner == current_user
      flash[:alert] = "You need admin access to edit this project or invite new users"
      redirect_to projects_path
    end
  end

  def require_owner_user
    if !@project.owner == current_user
      flash[:alert] = "You need owner access to delete this project"
      redirect_to projects_path
    end
  end

end