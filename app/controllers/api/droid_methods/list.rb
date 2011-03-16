class Api::DroidController < ApiController
  
  def list_1
    render :json => Droid.all
  end
  
  def list_2
    render :json => Droid.all.map {|d| d.as_json(:version => 2)}
  end
  
end