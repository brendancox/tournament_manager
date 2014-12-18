require 'rails_helper'

describe Tournament do 
	it 'invalid without a name' do
		tournament = Tournament.new(activity_id: 1)
		expect(tournament).not_to be_valid
	end

	it 'invalid without an activity_id' do
		tournament = Tournament.new(name: 'local football')
		expect(tournament).not_to be_valid
	end

	it 'should save standard activity' do
		tournament = Tournament.create(name: 'local football', activity_id: 1)
		expect(Tournament.where(name: 'local football')).to be_truthy
	end
end