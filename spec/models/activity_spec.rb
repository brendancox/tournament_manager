require 'rails_helper'

describe Activity do 
	it 'invalid without a name' do
		activity = Activity.new
		expect(activity).not_to be_valid
	end

	it 'should save standard activity' do
		activity = Activity.create(name: 'football')
		expect(Activity.where(name: 'football')).to exist
	end
end