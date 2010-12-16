# == Schema Information
# Schema version: 20101208215725
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean
#


require 'digest'
class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation

  has_many :microposts, :dependent => :destroy
  has_many :relationships, :foreign_key => 'follower_id', :dependent => :destroy
  has_many :reverse_relationships,  :foreign_key => 'followed_id', 
                                    :class_name => 'Relationship', 
                                    :dependent => :destroy
  has_many :followers, :through => :reverse_relationships, :source => :follower
  has_many :following, :through => :relationships, :source => :followed

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :name, 
    :presence => true,
    :length => { :maximum => 50 },
    :uniqueness => true

  validates :email, 
    :presence => true,
    :format => { :with => email_regex },
    :uniqueness => true

  validates :password, 
    :presence => true,
    :confirmation => true,
    :length => { :within => 6..40 }
  
  before_save :encrypt_password, :normalize_fields

  scope :admin, where(:admin => true)

  def self.search(search)
    if search
      find(:all, :conditions => ['name LIKE ?', "%#{search}%"])
    else
      find(:all)
    end
  end

  def feed
    Micropost.from_users_followed_by(self)
  end

  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    email.strip!
    email.downcase!
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  def following?(followed)
    relationships.find_by_followed_id(followed)
  end

  def follow!(followed)
    relationships.create!(:followed_id => followed.id)
  end

  def unfollow!(followed)
    relationships.find_by_followed_id(followed).destroy
  end

  private
  def normalize_fields  # called before User.save
    self.email.downcase!
    self.name.downcase!
    self.name.tr!(' ', '_')
  end

  def encrypt_password
    return if password.nil?
    self.salt = make_salt if new_record?
    self.encrypted_password = encrypt(self.password)
  end

  def encrypt(string)
    secure_hash("#{self.salt}--#{string}")
  end

  def make_salt
    secure_hash("#{Time.now.utc}--#{self.password}")
  end

  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end
end



























