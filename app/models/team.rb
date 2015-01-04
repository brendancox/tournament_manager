class Team < ActiveRecord::Base
  has_many :tournaments, through: :participants
  has_many :participants
  has_many :standings
	validates :name, presence: true
end
