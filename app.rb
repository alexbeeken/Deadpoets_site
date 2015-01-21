require("sinatra")
require("sinatra/reloader")
require("./lib/candidate")
require('pg')
require('pry')

DB = PG::Connection.open(:dbname => 'dc4clh7i0hvanm', :host => 'ec2-54-225-101-64.compute-1.amazonaws.com', :port => '5432', :password => 'REMOVED', :user => 'ndpcmhkggeejyz')

configure :development do
  set :bind, '0.0.0.0'
  set :port, 3000
end

=begin 
TODO make a user class that holds current user information

=end

get('/') do
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
  @name = params.fetch('name').downcase()
  @password = params.fetch('password')
  @row = DB.exec("SELECT * FROM users WHERE name = '#{@name}';")
  if (@row.ntuples > 0)
    if @row[0]["password"] == @password
      erb(:login_success)
    end
  else
    erb(:login_failed)
  end
end

post('/add_a_user') do
  @name = params.fetch('name').downcase()
  @password = params.fetch('password')
  @email = params.fetch('email')
  @rows = DB.exec("SELECT * FROM users;")
  @id = @rows.ntuples
  @statement = "INSERT INTO \"users\" (\"id\", \"name\", \"password\",\"voted\", \"email\" ) VALUES (#{@id}, '#{@name}', '#{@password}', 'f', '#{@email}');"
  DB.exec(@statement)
  erb(:add_a_user_success)
end

post("/voting_page") do
  @table = DB.exec("SELECT * FROM voting_booth;")
  @user = params.fetch('user').downcase()
  @already_voted = DB.exec("SELECT * FROM users WHERE name = '#{@user}';")
  if @already_voted == 't'
    erb(:already_voted)
  else
    erb(:voting_page)
  end
end

post("/vote_submit") do
  @vote = params.fetch('ballot')
  @user = params.fetch('user').downcase()
  @already_voted = DB.exec("SELECT voted FROM users WHERE name = '#{@user}';")
  if @already_voted[0]["voted"] == 't'
    DB.finish
    erb(:already_voted)
  else
  @current_count = DB.exec("SELECT votes FROM voting_booth WHERE id = #{@vote};")
  DB.exec("UPDATE voting_booth SET votes = #{@current_count[0]["votes"].to_i + 1} WHERE id = #{@vote};")
  DB.exec("UPDATE users SET voted='t' WHERE name='#{@user}';")
    erb(:voting_success)
  end
end

post('/add_a_place') do
  @table = DB.exec("SELECT * FROM voting_booth;")
  @place = params.fetch('add_text')
  @user = params.fetch('user').downcase()
  @id = @table.ntuples
  @statement = "INSERT INTO \"voting_booth\" (\"id\", \"placename\", \"votes\") VALUES (#{@id}, '#{@place}', 0);"
  DB.exec(@statement)
  erb(:add_a_place_success)
end
