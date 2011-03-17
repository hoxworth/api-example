class Api::DroidController < ApiController
  def list_1
    render :json => Droid.all
  end
  
  def list_2
    render :json => Droid.all.map {|d| d.as_json(:version => 2)}
  end
  
  def view_1
    droid = Droid.find_by_id(params[:id])
    render :json => {:error => "Droid #{params[:id]} not found"}, :status => 404 and return if droid.nil?
    render :json => droid
  end
end
