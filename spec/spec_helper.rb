require('rspec')
require('pg')
require('pry')

DB = PG::Connection.open(:dbname => 'dc4clh7i0hvanm', :host => 'ec2-54-225-101-64.compute-1.amazonaws.com', :port => '5432', :password => 'REMOVED', :user => 'ndpcmhkggeejyz')

RSpec.configure do |config|
config.after(:each) do
  DB.exec("DELETE FROM voting_booth;")
end
end
