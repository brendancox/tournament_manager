require 'rails_helper'

def new_tournament_first_page
	visit "/tournaments/new"
	fill_in 'Name', with: "Football Tournament"
	select 'Football', from: 'Activity'
	click_button "Next"
end

def new_tournament_second_page
	check('Alpha')
	check('Beta')
	check('Gamma')
	check('Delta')
	click_button "Generate Schedule"
end

describe "Creating tournaments" do 
	before :each do 
		load_factories
	end

	context "Generate basic tournament" do
		it "Arrives at add teams page" do
			new_tournament_first_page
			expect(page).to have_text('Add teams')
		end

		context "add all teams" do
			before do 
				new_tournament_first_page
				new_tournament_second_page
			end

			it "Arrives at show tournament page" do
				expect(page).to have_text('Football Tournament')
			end
		end
	end
end