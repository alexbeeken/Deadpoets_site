class SQL

  define_singleton_method(:connect) do
    PG::Connection.open(:dbname => 'dc4clh7i0hvanm', :host => 'ec2-54-225-101-64.compute-1.amazonaws.com', :port => '5432', :password => 'REMOVED', :user => 'ndpcmhkggeejyz')
  end
end
