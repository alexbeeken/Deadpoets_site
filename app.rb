require("sinatra")
require("sinatra/reloader")
require('./lib/candidate')
require('./lib/user')
require('pg')
require('pry')
require('./lib/services')
require 'sinatra/captcha'
require 'yelp'

DB = Services.sql_connect

YELP = Services.yelp_connect

=begin
configure :development do
  set :bind, '0.0.0.0'
  set :port, 3000
end
=end

get '/' do
  erb(:home)
end

get('/friday_vote') do
  @election = Candidate.all()
  erb(:friday_vote)
end

get('/login_form') do
  erb(:login_form)
end

post('/login') do
  @name = params.fetch('name')
  @password = params.fetch('password')
  if User.authenticate?(@name, @password)
    @user = User.find_user_by_name(@name)
    @user.login
    erb(:login_success)
  else
    erb(:login_failed)
  end
end

post('/add_a_user') do
  halt(401, "invalid captcha") unless captcha_pass?
  @name = params.fetch('name')
  @password = params.fetch('password')
  @email = params.fetch('email')
  new_user = User.new({:name => @name, :password => @password, :email => @email, :id => 5000, :voted => 'f'})
  new_user.save()
  erb(:add_a_user_success)
end

post("/voting_page") do
  @election = Candidate.all
    erb(:voting_page)
  end

post("/vote_submit") do
  @candidate_id = params.fetch('ballot')
  @user = User.get_current_user
  if @user.voted == 't'
    erb(:already_voted)
  else
    @candidate = Candidate.find_candidate_by_id(@candidate_id)
    @candidate.vote_alter(1)
    @user.update_voted_for_user_id(@user.id)
    erb(:voting_success)
  end
end

post('/add_a_place') do
  name = params.fetch('add_text')
  description = params.fetch('description')
  @new_candidate = Candidate.new({:name => name, :description => description, :id => 6000})
  @new_candidate.save()
  erb(:add_a_place_success)
end
