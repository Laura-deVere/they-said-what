require 'sinatra'
require 'sinatra/activerecord'
require 'bundler/setup'
require 'rack-flash'
require './models'

configure(:development) { set :database, "sqlite3:login.sqlite3" }

get '/' do 
	erb :home
end
