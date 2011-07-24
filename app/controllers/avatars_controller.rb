class AvatarsController < ApplicationController
  before_filter :load_location
   

  def new
    @avatar = @location.avatars.build
  end
  
  def create    
    @avatar = @location.avatars.build(params[:avatar])
    if @avatar.save
      flash[:notice] = "Photo uploaded successfully!"
      #      @location.update_attribute("location_status", params[:location_status])
      return redirect_to locations_path
    else
      flash[:notice] = "unable to save photo!"
      return render :action =>"new"
    end
  end

  def edit
    @avatar = @location.avatars.find_by_id(params[:id])
  end

  def destroy
    @avatar = Avatar.find_by_id(params[:id])
    if @avatar.destroy
      return redirect_to new_location_avatar_path(@location)
    else
      flash[:notice] = "unable to delete photo!"
      return render :action =>"new"
    end
  end

  protected
  
  def load_location
    @location = Location.find_by_id(params[:location_id])
  end
end
