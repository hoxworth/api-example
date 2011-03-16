ApiExample::Application.routes.draw do

  scope 'api(/:version)', :module => :api, :version => /v\d+?/ do 
    get 'droids'      => "droid#list",  :as => "api_droid_list"
    get 'droids/:id'  => "droid#view",  :as => "api_droid_view"
  end
  
end
