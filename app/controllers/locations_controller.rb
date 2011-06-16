class LocationsController < ApplicationController
  before_filter :require_user
  layout 'inner'

  def index
    @locations = current_user.locations 
  end

  def search_location
    @locations = Location.all
    @map = GMap.new("map")
    @map.control_init(:map_type => true, :small_zoom => true)

    @locations.each do |location|
      coordinates = [location.latitude,location.longitude]
      @map.center_zoom_init(coordinates, 15)
      @map.overlay_init(GMarker.new(coordinates,:title => current_user.first_name, :info_window => "#{location.headline}"))
    end

  end
  
  def new
    @location = Location.new
    @features = Feature.all
    @map = GMap.new("map")
    @map.control_init(:map_type => true, :small_zoom => true)
    @map.center_zoom_init([37.09, -95.71], 15)
  end

  def create
    @location = Location.new(params[:location])
    @location.feature_ids = params[:features]
    if @location.save
      flash[:notice] = "Location saved successfully!"
      redirect_to new_location_avatar_path(@location)
    else
      @features = Feature.all
      flash[:notice] = "Location was not saved successfully!"
      render :action => "new"
    end    
  end

  def edit    
    @location = Location.find_by_id(params[:id])
    @features = Feature.all
    @map = GMap.new("map")
    @map.control_init(:map_type => true, :small_zoom => true)    
    coordinates = [@location.latitude,@location.longitude]
    @map.center_zoom_init(coordinates, 15)
    @map.overlay_init(GMarker.new(coordinates,:title => current_user.first_name, :info_window => "#{@location.headline}"))
  end

  def update_location_status
    @location = Location.find_by_id(params[:id])
    @location.update_attribute("location_status", params["location_status_#{@location.id}"])
    render :update do |page|
      page["updated_location_msg_div_#{@location.id}"].show      
    end
  end

  def update_start_date
    @location = Location.find_by_id(params[:id])
    @location.update_attribute("start_date", params["location_#{@location.id}_start_date"])
    render :update do |page|
      page["updated_location_msg_div_#{@location.id}"].show
    end
  end

  def update
    @location = Location.find(params[:id])
    @location.feature_ids = params[:features]
    if @location.update_attributes(params[:location])      
      flash[:notice] = "Location updated successfully!"
      unless @location.avatars.blank?
        return redirect_to edit_location_avatar_path(@location,@location.avatars.first)
      else
        return redirect_to new_location_avatar_path(@location)
      end
    else 
      @features = Feature.all
      flash[:notice] = "Location was not updated successfully!"
      render :action => "edit"
    end    
  end

  def show
    @location = Location.find(params[:id])
    @map = GMap.new("map")
    @map.control_init(:map_type => true, :small_zoom => true)
    coordinates = [@location.latitude,@location.longitude]
    @map.center_zoom_init(coordinates, 15)
    @map.overlay_init(GMarker.new(coordinates,:title => current_user.first_name, :info_window => "#{@location.headline}"))
  end
end
