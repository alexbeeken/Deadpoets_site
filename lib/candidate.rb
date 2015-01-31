class Candidate
  attr_reader(:name, :description, :id)

  define_method(:initialize) do |attributes|
    @name = attributes.fetch(:name)
    @description = attributes.fetch(:description)
    @id = attributes.fetch(:id)
  end

  define_method(:save) do
    @id = DB.exec("SELECT * FROM voting_booth;").ntuples
    temp = DB.exec("INSERT INTO voting_booth (id, name, description, votes) VALUES (#{id}, '#{@name}', '#{@description}', 0);")
  end

  define_singleton_method(:all) do
    query = DB.exec("SELECT * FROM voting_booth;")
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
    query = DB.exec("SELECT votes FROM voting_booth WHERE id = #{@id}")
    query[0]["votes"]
  end

  define_method(:vote_alter) do |amount|
    new_count = DB.exec("UPDATE voting_booth SET votes = votes + #{amount} WHERE id = #{@id} RETURNING votes;")
    new_count
  end

  define_singleton_method(:find_candidate_by_id) do |id|
    returned_query = DB.exec("SELECT * FROM voting_booth WHERE id = #{id};")
    if returned_query.ntuples > 0
      hash = returned_query[0]
      name == hash.fetch("name")
      description = hash.fetch("description")
      votes = hash.fetch("votes").to_i
      return Candidate.new({:name => name, :description => description, :votes => votes, :id => id})
    else
      return false
    end
end
end
