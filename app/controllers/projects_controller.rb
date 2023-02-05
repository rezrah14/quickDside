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

end