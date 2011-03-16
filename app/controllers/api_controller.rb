require 'json'

class ApiController < ApplicationController  
  @@versions = {}
  @@registered_methods = {}
  
  class << self
    alias_method :original_inherited, :inherited
    def inherited(subclass)
      original_inherited(subclass)
      
      Dir["#{Rails.root}/app/controllers/api/#{subclass.to_s.split('::')[1].underscore.split('_').reject{|c|c == 'controller'}.join('_')}_methods/**/*.*"].each do |file|
        load file
      end
      
      subclass.action_methods.each do |method|
        
        regex = Regexp.new("^(.*)_(\\d+)$")
        if match = regex.match(method)
          key = "#{subclass.to_s}##{match[1]}"
          @@versions[match[2].to_i] = true
          @@registered_methods[key] ||= {}
          @@registered_methods[key][match[2].to_i] = true
        
          subclass.instance_eval do
            define_method(match[1].to_sym) {}
          end
        end
      end
      subclass.reset_action_methods
    end
  
    def reset_action_methods
      @action_methods = nil
      action_methods
    end
  end
  
  
  def versions
    render :json => @@versions.keys.sort.reverse and return
  end
  
  
  def no_api_method
    render :json => {"error" => "The requested method does not exist or is not enabled for the requested API version (v#{params[:version]})"}, :status => 404 and return
  end
  
  
  private
  def protected_actions
    ['versions','no_api_method']
  end

  alias_method :original_process_action, :process_action
  def process_action(method_name, *args)
    method = "no_api_method"
    if protected_actions.include? method_name
      method = method_name
    else
      if params[:version]
        params[:version] = params[:version][1,params[:version].length - 1].to_i
      else
        params[:version] = @@versions.keys.max
      end
      method = find_method(method_name, params[:version])
    end
    original_process_action(method, *args)
  end
  

  
  def find_method(method_name, version)
    key = "#{self.class.to_s}##{method_name}"
    versions = @@registered_methods[key].keys.sort
    
    final_method = 'no_api_method'

    versions.reverse.each do |v|
      if v <= version
        final_method = "#{method_name}_#{v}"
        break
      end
    end
    
    final_method
  end
  
end