require 'rails_helper'

feature "Creating tournaments" do 
	before :each do 
		create(:activity)
		create(:team)
		create(:beta)
		create(:gamma)
		create(:delta)
	end

	scenario "Generate basic tournament" do
		visit "/tournaments/new"

		fill_in 'Name', with: "Football Tournament"
		select 'Football', from: 'Activity'

		click_button "Next"

		expect(page).to have_text('Add teams')
	end
end