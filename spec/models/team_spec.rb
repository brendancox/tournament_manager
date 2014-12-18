require 'rails_helper'

describe Team do 
	it 'invalid without a name' do
		team = Team.new
		expect(team).not_to be_valid
	end

	it 'should save standard activity' do
		team = Team.create(name: 'alpha')
		expect(Team.where(name: 'alpha')).to be_truthy
	end
end