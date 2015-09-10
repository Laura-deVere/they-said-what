require 'sinatra'
require 'sinatra/activerecord'
require 'bundler/setup'
require 'rack-flash'
require './models'

configure(:development) { set :database, "sqlite3:login.sqlite3" }
set :sessions, true

def current_user
	if session[:user_id]
		User.find(session[:user_id])
	else
		nil
	end
end

get '/' do 
	erb :home
end

get '/settings' do 
	erb :settings
end

get '/profile' do 
	erb :profile
end

get '/signup' do 
	erb :signup
end


post '/signup' do
	user = User.create(params[:user])
	session[:user_id] = user.id
	redirect to '/'
end	

get '/logout' do 
	session[:user_id] = nil
	redirect to '/login'
end


post '/sessions' do 
	user = User.find_by(email: params[:email])
	if user and user.password == params['password']
		puts "Logged in successfully!"
		session[:user_id] = user.id 
		redirect to '/'
	else
		puts "Invalid Email or Password"
		redirect to '/login'
	end
end

get '/login' do 
	erb :login
end

