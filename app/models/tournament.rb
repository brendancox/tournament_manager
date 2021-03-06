class Tournament < ActiveRecord::Base
  has_many :teams, through: :participants
  has_many :participants
  has_many :fixtures
  has_many :standings
  accepts_nested_attributes_for :teams
  accepts_nested_attributes_for :participants
  validates :name, presence: true
  validates :activity_id, presence: true
  belongs_to :activity
  belongs_to :user
end
