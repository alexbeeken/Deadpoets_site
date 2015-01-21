require('pry')

class Candidate
  attr_reader(:name, :description)
  
  define_method(:initialize) do |attributes|
    @name = attributes.fetch(:name)
    @description = attributes.fetch(:description)
    @id = nil;
  end
  
  define_method(:save) do 
    temp = DB.exec("INSERT INTO test_voting_booth (name, description, votes) VALUES ('#{@name}', '#{@description}', 0) RETURNING id;")
    @id = temp[0]["id"]
  end

  define_singleton_method(:all) do
    query = DB.exec("SELECT * FROM test_voting_booth;")
    all = []
    query.each() do |candidates|
      name = candidates.fetch("name")
      description = candidates.fetch("description")
      id = candidates.fetch("id").to_i()
      all.push(Candidate.new({:name => name, :description => description, :id => id}))
   end
  all
 end
  
  define_method(:==) do |another_candidate|
    (self.name.==another_candidate.name).&(self.description.==another_candidate.description)
  end
  
  define_method(:vote_count) do
    query = DB.exec("SELECT votes FROM test_voting_booth WHERE id = #{@id}")
    query[0]["votes"]
  end
  
  define_method(:vote_alter) do |amount|
    new_count = DB.exec("UPDATE test_voting_booth SET votes = votes + #{amount} WHERE id = #{@id} RETURNING votes;")
    new_count
  end
    

end
