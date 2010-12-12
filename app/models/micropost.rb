# == Schema Information
# Schema version: 20101208215725
#
# Table name: microposts
#
#  id         :integer         not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Micropost < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user

  validates :content, :presence => true, :length => { :maximum => 140 }
  validates :user_id, :presence => true

  default_scope :order => 'microposts.created_at DESC'
  scope :from_users_followed_by, lambda { |user| followed_by(user) }

  private
  def self.followed_by(user)
    myquery = "user_id IN (SELECT followed_id FROM relationships WHERE follower_id = " + 
              user.id + ") OR user_id = " + user.id
    where(myquery)
  end
end
