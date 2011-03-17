class Droid < ActiveRecord::Base
  alias_method :orig_as_json, :as_json
  
  def as_json(options = {})
    base = orig_as_json
    
    if options[:version] == 2
      base = {'name' => self.name}
    end
    
    base
  end
end
