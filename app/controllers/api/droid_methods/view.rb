class Api::DroidController < ApiController
  
  def view_1
    droid = Droid.find_by_id(params[:id])
    render :json => {:error => "Droid #{params[:id]} not found"}, :status => 404 and return if droid.nil?
    render :json => droid
  end
  
end