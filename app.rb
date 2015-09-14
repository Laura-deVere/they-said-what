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
	@users = User.all
	@new_posts = Post.all
	erb :home
end

get '/profile' do
	@user = current_user
	@post = current_user.posts
	erb :show
end

get '/account' do
	@user = current_user
	erb :account
end	

post '/account' do
	current_user.update(params[:user])
	redirect to '/'
end	


get '/follow/:id' do
	@relationship = Relationship.create(follower_id: current_user.id,
																				followed_id: params[:id])
	redirect to '/'
end

get '/unfollow/:id' do 
	@relationship = Relationship.find_by(follower_id: current_user,
																				followed_id: params[:id])
	@relationship.destroy
	redirect to '/'
end	

get '/users/:id' do
	begin
		@user = User.find(params[:id])
		@post = Post.find(params[:id])
		erb :show
	rescue
		redirect to "/"	
	end	
end	

get '/signup' do 
	erb :signup
end


post '/signup' do
	user = User.create(params[:user])
	session[:user_id] = user.id
	redirect to '/'
end	

post '/posting' do 
	@new_post = Post.new(params[:post])
	@new_post.user_id = current_user.id
	@new_post.save
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

