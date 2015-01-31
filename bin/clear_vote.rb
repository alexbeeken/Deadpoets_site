#!/usr/bin/env ruby

require "./lib/services.rb"
require "pg"

DB = Services.sql_connect
puts "Clearing the Vote Tables"
DB.exec("DELETE FROM voting_booth;")
puts "Setting user voted field to false"
DB.exec("UPDATE users SET voted = 'f';")
puts "Finished."
