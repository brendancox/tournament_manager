FactoryGirl.define do 
	factory :team do 
		name "Alpha"

		factory :beta do
			name "Beta"
		end

		factory :gamma do
			name "Gamma"
		end

		factory :delta do
			name "Delta"
		end

		factory :extra_teams do
			sequence(:name) {|n| "extra#{n}"}
		end
	end
end