class User
  attr_reader(:id, :name, :password, :email, :voted, :logged_in)
  @@current_user = nil

  define_method(:initialize) do |attributes|
    @id = attributes.fetch(:id)
    @name = attributes.fetch(:name)
    @password = attributes.fetch(:password)
    @email = attributes.fetch(:email)
    @voted = attributes.fetch(:voted)
    @logged_in = false
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO users (name, password, email, voted) VALUES ('#{@name}', '#{@password}', '#{@email}', '#{@voted}') RETURNING id;")
    @id = result[0]["id"].to_i
  end

  define_singleton_method(:all) do
    returned_query = DB.exec("SELECT * FROM users;")
    users = []
    returned_query.each() do |hash|
      name = hash.fetch("name")
      id = hash.fetch("id").to_i()
      password = hash.fetch("password")
      email = hash.fetch("email")
      voted = hash.fetch("voted")
      users.push(User.new({:name => name, :id => id, :password => password, :email => email, :voted => voted}))
    end
    users
  end

  define_method(:update_voted_for_user_id) do |id|
    result = DB.exec("UPDATE users SET voted = 't' WHERE id = #{id} RETURNING voted;")
    @voted = result[0]["voted"]
  end

  define_method(:==) do |another_user|
    (self.id.==another_user.id).&(self.name.==another_user.name).&(self.password.==another_user.password).&(self.email.==another_user.email).&(self.voted.==another_user.voted)
  end

  define_singleton_method(:authenticate?) do |username, password|
    returned_query = DB.exec("SELECT * FROM users WHERE name = '#{username}' AND password = '#{password}';")
    if returned_query.ntuples == 1
      return true
    else
      return false
    end
  end

  define_method(:login) do
    @logged_in = true;
    @@current_user = self;
  end

  define_method(:logout) do
    @@current_user = nil;
    @logged_in = false;
  end

  define_singleton_method(:find_user_by_name) do |name|
    hash = DB.exec("SELECT * FROM users WHERE name='#{name}';")
      if hash.ntuples == 1
        hash = hash[0]
        if name == hash.fetch("name")
          id = hash.fetch("id").to_i
          password = hash.fetch("password")
          email = hash.fetch("email")
          voted = hash.fetch("voted")
          return User.new({:name => name, :id => id, :password => password, :email => email, :voted => voted})
        end
      else
        return false
      end
    end

  define_singleton_method(:get_current_user) do
    @@current_user
  end
end
