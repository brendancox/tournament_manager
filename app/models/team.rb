class Team < ActiveRecord::Base
	belongs_to :users
  has_many :tournaments, through: :participants
  has_many :participants
  has_many :standings
	validates :name, presence: true
end
