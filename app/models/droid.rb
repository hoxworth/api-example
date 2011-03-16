class Droid < ActiveRecord::Base
  alias_method :orig_as_json, :as_json
  def as_json(options = {})
    
    base = {'name' => self.name}
    
    if options[:version] == 2
      base = orig_as_json
    end
    
    base
  end
end
