require 'sinatra'
require_relative 'bomb'
require 'haml'
require 'pry'
enable :sessions

get '/' do
  haml :index
end

post '/' do
  @bomb = Bomb.new

  session[:flash] = ""

  session[:flash] << "Activation code set to default value\n" if params[:activation_code].empty?
  session[:flash] << "Deactivation code set to default value\n" if params[:deactivation_code].empty?
  
  activation_set = @bomb.activation_code(params[:activation_code])
  deactivation_set = @bomb.deactivation_code(params[:deactivation_code])

  session[:flash] << "Activation code set\n" if activation_set
  session[:flash] << "Deactivation code set\n" if deactivation_set

  session[:flash] << "Invalid activation code: must be 4 numerical digits\n" if !activation_set
  session[:flash] << "Invalid deactivation code: must be 4 numerical digits\n" if !deactivation_set
  
  session[:bomb] = @bomb  

  haml :bomb
end

post '/activate' do
  @bomb = session[:bomb]
  
  if @bomb.state == :activated
    session[:flash] = "Bomb is activated"
  else
    @bomb.activate(params[:activation_code])
    session[:flash] = "Wrong activation code"
  end
  
  haml :bomb
end

post '/deactivate' do
  @bomb = session[:bomb]
  if @bomb.state == :deactivated
    session[:flash] = "Bomb is already deactivated"
  else 
    @bomb.deactivate(params[:deactivation_code])
    session[:flash] = "Wrong deactivation code"
  end
  haml :bomb
end

def h(text)
  Rack::Utils.escape_html(text)
end
