class Tournament < ActiveRecord::Base
  has_many :teams, through: :participants
  has_many :participants
  accepts_nested_attributes_for :teams
  accepts_nested_attributes_for :participants
end
