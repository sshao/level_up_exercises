require 'rubygems'
require 'bundler'
Bundler.require(:default, :development)

require 'sinatra'
require_relative "models/bomb"

enable :sessions

get '/stylesheets/:name.css' do
  content_type 'text/css', :charset => 'utf-8'
  scss(:"../assets/stylesheets/#{params[:name]}")
end

get '/javascript/:name.js' do
  coffee :"../assets/javascript/#{params[:name]}"
end

get '/' do
  haml :index
end

post '/create' do
  @bomb = Bomb.new

  alerts = ""
  successes = ""
  errors = ""

  if params[:activation_code].empty?
    # FIXME get rid of <br>s 
    alerts << "Activation code set to default value<br/>"
  else
    activation_set = @bomb.set_activation_code(params[:activation_code])
    if activation_set
      successes << "Activation code set<br/>"
    else
      errors << "Invalid activation code: must be 4 numerical digits<br/>"
    end
  end

  if params[:deactivation_code].empty?
    alerts << "Deactivation code set to default value<br/>"
  else
    deactivation_set = @bomb.set_deactivation_code(params[:deactivation_code])
    if deactivation_set
      successes << "Deactivation code set<br/>"
    else
      errors << "Invalid deactivation code: must be 4 numerical digits<br/>"
    end
  end

  flash[:alert] = alerts
  flash[:success] = successes
  flash[:error] = errors
  
  session[:bomb] = @bomb  

  redirect to("/bomb")
end

get '/bomb' do
  @bomb = session[:bomb]
  haml :bomb
end

post '/activate' do
  @bomb = session[:bomb]
  error = ""
  
  if @bomb.state == :activated
    error = "Bomb is already activated"
  else
    unless @bomb.activate(params[:activation_code])
      error = "Wrong activation code"
    end
  end

  if request.xhr?
    flash.now[:error] = error
    haml :_flash_and_state, :layout => false
  else
    flash[:error] = error
    redirect to("/bomb")
  end
end

post '/deactivate' do
  @bomb = session[:bomb]
  error = ""

  if @bomb.state == :deactivated
    error = "Bomb is already deactivated"
  else 
    error = "Wrong deactivation code" unless @bomb.deactivate(params[:deactivation_code])
  end
  
  if request.xhr?
    flash.now[:error] = error
    haml :_flash_and_state, :layout => false 
  else
    flash[:error] = error
    redirect to("/bomb")
  end
end

