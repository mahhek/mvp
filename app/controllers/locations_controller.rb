class LocationsController < ApplicationController
  before_filter :require_user
  
  def new
    @location = Location.new
    @features = Feature.all
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
end
