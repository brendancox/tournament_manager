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
	end
end