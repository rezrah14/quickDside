class AssetsController < ApplicationController
  def index
    @project = Project.find(params[:project_id])
    @assets = @project.assets.includes(:project).paginate(page: params[:page], per_page: 10)
  end

  def new
    @project = Project.find(params[:project_id])
    @asset = Asset.new
  end

  def create
    @project = Project.find(params[:project_id])
    @asset = @project.assets.build(asset_params)
  
    if @asset.save
      redirect_to project_assets_path(@project), notice: 'Asset was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @project = Project.find(params[:project_id])
    @asset = Asset.find(params[:id])
  end

  def update
    # Your code for handling the update of an existing asset
  end

  def destroy
    # Your code for deleting an existing asset
  end

  private

  def asset_params
    params.require(:asset).permit(:name, :company_name, :region, :asset_type, :start_date, :end_date)
  end

end
