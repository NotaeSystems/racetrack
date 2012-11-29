class League < ActiveRecord::Base
  has_many :leagueusers
  has_many :users , :through => :leagueusers 
  has_many :trackleagues
  has_many :tracks , :through => :trackleagues
  has_many :meetleagues
   has_many :meets , :through => :trackleagues 
  attr_accessible :active, :description, :name, :owner_id, :status
end
