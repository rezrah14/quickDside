class ComponentsController < ApplicationController
  before_action :set_project

  def index
    @components = @project.components
  end

  def new
    @project = Project.find(params[:project_id]) # Fetch the associated project
    @component = @project.components.new
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end
end
