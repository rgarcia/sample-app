# == Schema Information
# Schema version: 20110208015552
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
#

require 'digest'

class User < ActiveRecord::Base
  # create a virtual password attribute 
  # a virtual attribute doesn't actually exist in the db
  attr_accessor :password

  attr_accessible :name, :email, :password, :password_confirmation

  validates :name,  :presence => true,
                    :length   => { :maximum => 50 }
  validates :email, :presence   => true,
                    :format     => { :with => /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    :uniqueness => { :case_sensitive => false }

  # automatically creates a virtual password_confirmation attribute
  validates :password, :presence => true,
                       :confirmation => true,
                       :length => { :within => 6..40 }

  # register a callback before records are saved to the db
  before_save :encrypt_password

  # return true if a user's submitted password matches the stored encrypted password
  def has_password?(submitted_password)
    self.encrypted_password == encrypt(submitted_password)
  end

  # static method that tries to match a user via email and pass
  def User.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end

  private
  
  def encrypt_password
    self.salt = make_salt if new_record?
    self.encrypted_password = encrypt(self.password)
  end

  def encrypt(string)
    secure_hash("#{self.salt}--#{string}")
  end

  # salt is a unique string for each user, used to obfuscate the hashed plaintext password
  # the salt is only generated when the user is created
  def make_salt
    secure_hash("#{Time.now.utc}--#{self.password}")
  end
  
  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end

end
