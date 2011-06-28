class LocationsController < ApplicationController

  before_filter :require_user, :only => [:new,:create]
    
  def index
    @locations = current_user.locations 
  end

  def send_contact_me_message
    render :nothing => true
  end

  def search_location
    
    query = "1=1"
    query = query + " AND start_date <= #{params[:request_date]}" unless params[:request_date].blank? or params[:request_date] == "mm / dd / yy"
    query = query + " AND ( city = '#{params[:requested_city]}' OR nearest_metro = '#{params[:requested_city]}' ) " unless params[:requested_city] == "Add My City!"
    query = query + " AND park_store = '#{params[:storage_menus]}'" unless params[:storage_menus] == "Both"
    query = query + " AND location_status = 'Show Listing'"
    

    @locations = Location.paginate(:all, :conditions => [] ,:page => params[:page], :per_page => 3, :order => "price ASC")
    @city = params[:requested_city] unless params[:requested_city] == "Add My City!"
    @park_store = params[:storage_menus]

    @map = GMap.new("map")
    @map.control_init(:map_type => true, :small_zoom => true)

    sorted_latitudes = @locations.collect(&:latitude).compact.sort
    sorted_longitudes = @locations.collect(&:longitude).compact.sort
    @map.center_zoom_on_bounds_init([
        [sorted_latitudes.first, sorted_longitudes.first],
        [sorted_latitudes.last, sorted_longitudes.last]])

    if @locations.size == 1
      @map.center_zoom_init([sorted_latitudes.first, sorted_longitudes.first], 15)
    end

    if @locations.size == 0
      @map.center_zoom_init([40.71435, -74.00597], 12)
    end


    @locations.each do |location|
      coordinates = [location.latitude,location.longitude]
      @map.overlay_init(GMarker.new(coordinates,:title => current_user.nil? ? location.headline : current_user.first_name, :info_window => "#{location.headline}"))
    end
  end

  def save_requested_city
    if !params[:other_request_city].blank? and params[:other_request_city] != "Please enter your zip code"
      RequestedCity.new(:name => params[:other_request_city], :email => params[:email]).save
      render :update do |page|
        page["other_requested_city_div"].hide
        page["requested_city_msg_div"].show
        page["requested_city_msg_div"].replace_html :text => "We will be in touch once we launch in your area."
      end
    else
      render :update do |page|
        page["requested_city_msg_div"].show
        page["requested_city_msg_div"].replace_html :text => "Please provide some zip code!"
      end
    end
  end
  
  def new
    @location = Location.new
    @features = Feature.all
    @map = GMap.new("map")
    @map.control_init(:map_type => true, :small_zoom => true)
    @map.center_zoom_init([37.09, -95.71], 3)
  end

  def create
    @location = Location.new(params[:location])
    @location.feature_ids = params[:features]
    if @location.save
      flash[:notice] = "Location saved successfully!"
      redirect_to new_location_avatar_path(@location)
    else
      @map = GMap.new("map")
      @map.control_init(:map_type => true, :small_zoom => true)
      @map.center_zoom_init([37.09, -95.71], 4)
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
    @map.overlay_init(GMarker.new(coordinates,:title => current_user.nil? ? @location.headline : current_user.first_name, :info_window => "#{@location.headline}"))
  end
end
