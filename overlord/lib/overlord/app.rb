require 'sinatra'
require 'sinatra/flash'
require 'haml'
require_relative 'bomb'

require 'pry'

enable :sessions

get '/' do
  haml :index
end

post '/create' do
  @bomb = Bomb.new

  alerts = ""
  successes = ""
  errors = ""

  if params[:activation_code].empty?
    alerts << "Activation code set to default value\n"
  else
    activation_set = @bomb.activation_code(params[:activation_code])
    if activation_set
      successes << "Activation code set\n"
    else
      errors << "Invalid activation code: must be 4 numerical digits\n"
    end
  end

  if params[:deactivation_code].empty?
    alerts << "Deactivation code set to default value\n"
  else
    deactivation_set = @bomb.deactivation_code(params[:deactivation_code])
    if deactivation_set
      successes << "Deactivation code set\n"
    else
      errors << "Invalid deactivation code: must be 4 numerical digits\n"
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
  
  if @bomb.state == :activated
    flash[:error] = "Bomb is activated"
  else
    unless @bomb.activate(params[:activation_code])
      flash[:error] = "Wrong activation code"
    end
  end
  
  redirect to("/bomb")
end

post '/deactivate' do
  @bomb = session[:bomb]
  if @bomb.state == :deactivated
    flash[:error] = "Bomb is already deactivated"
  else 
    flash[:error] = "Wrong deactivation code" unless @bomb.deactivate(params[:deactivation_code])
  end
  
  redirect to("/bomb")
end

def h(text)
  Rack::Utils.escape_html(text)
end
