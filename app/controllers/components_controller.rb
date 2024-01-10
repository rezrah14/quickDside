class ComponentsController < ApplicationController
  before_action :set_project
  before_action :set_component, only: [:show, :edit, :update, :destroy]

  def index
    @components = @project.components
  end

  def show
  end

  def new
    @component = @project.components.new
  end

  def edit
  end

  def create
    @component = @project.components.new(component_params.except(:date_price_pairs))
    if @component.save
      process_date_price_data(@component, params[:component][:date_price_pairs])
      redirect_to project_component_path(@project, @component)
    else
      # If save fails, re-render the new form to display errors
      render :new
    end
  end

  def update
    if @component.update(component_params.except(:date_price_pairs))
      process_date_price_data(@component, component_params[:date_price_pairs])
      redirect_to project_component_path(@component.project, @component), notice: 'Component was successfully updated.'
    else
      render :edit
    end
  end  

  def destroy
    @component.destroy
    redirect_to project_components_path(@project)
  end

  private

  def process_date_price_data(component, date_price_pairs)
    return unless date_price_pairs.present?
  
    date_price_data = JSON.parse(date_price_pairs)
  
    time_series_attribute = component.time_series_attribute || component.build_time_series_attribute(name: "#{component.name} Price")
  
    # Clear existing time series data points
    time_series_attribute.time_series_data_points.destroy_all
  
    date_price_data.each do |pair|
      date = pair['date']
      price = pair['price']
  
      data_point = time_series_attribute.time_series_data_points.build(date: date, value: price)
  
      unless data_point.save
        Rails.logger.error("Error saving TimeSeriesDataPoint: #{data_point.errors.full_messages.join(', ')}")
        raise ActiveRecord::RecordInvalid, data_point
      end
    end
  end  
  

  def component_params
    params.require(:component).permit(:name, :quantity_type, :unit, :unit_multiplier, :price_interpolation_model, :currency, :date_price_pairs)
  end


  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_component
    @component = @project.components.find(params[:id])
  end

end
