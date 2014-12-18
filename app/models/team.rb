class Team < ActiveRecord::Base
  has_many :tournaments, through: :participants
  has_many :participants
	validates :name, presence: true
end
