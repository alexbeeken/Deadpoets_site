class Voting_Entry
  attr_reader(:id,:placename,:votes)
  @@entries = []
  
  define_method(:initialize) do |attributes|
    @id = attributes.fetch(:id)
    @placename = attributes.fetch(:placename)
    @votes = attributes.fetch(:votes)
  end
  
  #TODO add a method to increment the vote
  
  #TODO add a method to add another place to the database
  
  #TODO add a method to delete a place from the database
end
   