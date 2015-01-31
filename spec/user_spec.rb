require('spec_helper')
require('user')

describe('#name') do
    it('returns the name of a new user object') do
    test_user = User.new({:name => "Test", :password => "12345abcdefg", :email => "foobar@foobar.com", :id => nil})
    expect(test_user.name).to(eq("Test"))
    end
  end

describe('#password') do
    it('retrieves the password of a new user object') do
    test_user = User.new({:name => "Test", :password => "12345abcdefg", :email => "foobar@foobar.com", :id => nil})
    expect(test_user.password).to(eq("12345abcdefg"))
    end
  end

describe('#email') do
    it('returns the email of a new user object') do
    test_user = User.new({:name => "Test", :password => "12345abcdefg", :email => "foobar@foobar.com", :id => nil})
    expect(test_user.email).to(eq("foobar@foobar.com"))
    end
  end

describe('#voted') do
   it('returns whether or not a user has voted, should be false for new user') do
   test_user = User.new({:name => "Test", :password => "12345abcdefg", :email => "foobar@foobar.com", :id => nil})
   expect(test_user.voted).to(eq("f"))
  end
end

describe('#save') do
  it('saves the user to the database') do
    test_user = User.new({:name => "Test", :password => "12345abcdefg", :email => "foobar@foobar.com", :id => nil})
    test_user.save()
    expect(User.all()).to(eq([test_user]))
  end
end

describe('.all') do
  it('returns an array of all user objects') do
    expect(User.all()).to(eq([]))
  end
end

describe('#update_voted') do
  it('updates the users voted field to "t"') do
    test_user = User.new({:name => "Test", :password => "12345abcdefg", :email => "foobar@foobar.com", :id => nil})
    test_user.save()
    test_user.update_voted
    expect(test_user.voted).to(eq('t'))
  end
end

describe('#==') do
  it('correctly returns comparison of two users') do
    test_user = User.new({:name => "Test", :password => "12345abcdefg", :email => "foobar@foobar.com", :id => nil})
    test_user2 = User.new({:name => "Test", :password => "12345abcdefg", :email => "foobar@foobar.com", :id => nil})
    expect(test_user).to(eq(test_user2))
  end
end

describe('.authenticate?') do
  it('allows a user to login if password matches database') do
    test_user = User.new({:name => "Test", :password => "12345abcdefg", :email => "foobar@foobar.com", :id => nil})
    test_user.save()
    expect(User.authenticate?("Test", "12345abcdefg")).to(eq(true))
  end
end

describe('#login') do
  it('updates the current user to be logged in') do
    test_user = User.new({:name => "Test", :password => "12345abcdefg", :email => "foobar@foobar.com", :id => nil})
    test_user.save()
    if User.authenticate?("Test", "12345abcdefg")
      test_user.login
    end
    expect(test_user.logged_in).to(eq(true))
  end
end

describe('#logout') do
  it('updates the current user to be logged out') do
    test_user = User.new({:name => "Test", :password => "12345abcdefg", :email => "foobar@foobar.com", :id => nil})
    test_user.save()
    test_user.logout
    expect(test_user.logged_in).to(eq(false))
  end
end

describe('.find_user_by_name') do |name|
  it('finds the user object with the given name') do
    test_user = User.new({:name => "Test", :password => "12345abcdefg", :email => "foobar@foobar.com", :id => nil})
    test_user.save()
    expect(User.find_user_by_name(test_user.name)).to(eq(test_user))
  end
end
