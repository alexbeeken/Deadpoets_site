require('rspec')
require('spec_helper')
require('candidate')

describe('#name') do
  it 'returns the name of a new candidate' do
    test_candidate = Candidate.new({:name => "George Bush", :description => "Republican from Texas"})
    expect(test_candidate.name).to(eq("George Bush"))
  end
  
describe('#description') do
  it 'returns the description of a new candidcate' do
    test_candidate = Candidate.new({:name => "George Bush", :description => "Republican from Texas"})
    expect(test_candidate.description).to(eq("Republican from Texas"))
  end
 end

describe('#save') do
  it 'saves the candidate into a database' do
    test_candidate = Candidate.new({:name => "George Bush", :description => "Republican from Texas"})
    test_candidate.save()
    expect(Candidate.all).to(eq([test_candidate]))
  end
end

describe('.all') do
  it 'returns an array of all saved candidates' do
    test_candidate = Candidate.new({:name => "George Bush", :description => "Republican from Texas"})
    test_candidate.save()
    expect(Candidate.all).to(eq([test_candidate]))
  end
end

describe('#vote_alter') do
  it 'alters the vote by the given amount' do
    test_candidate = Candidate.new({:name => "George Bush", :description => "Republican from Texas"})
    test_candidate.save()
    test_candidate.vote_alter(1)
    expect(test_candidate.vote_count).to(eq("1"))
  end
end

describe('#vote_count') do
  it 'returns the current number of votes for candidate by the given integer' do
    test_candidate = Candidate.new({:name => "George Bush", :description => "Republican from Texas"})
    test_candidate.save()
    test_candidate.vote_alter(2)
    expect(test_candidate.vote_count).to(eq("2"))
  end
end

describe('.find_candidate_by_id') do
  it 'returns the candidate object for a given id' do
    test_candidate = Candidate.new({:name => "George Bush", :description => "Republican from Texas"})
    test_candidate.save()
    expect(Candidate.find_candidate_by_id(test_candidate.id).to(eq(test_candidate)))
  end
end
end
