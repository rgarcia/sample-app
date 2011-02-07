require 'spec_helper'

describe User do

  before(:each) do
    @attr = { :name => "Example User", :email => "user@example.com" }
  end

  it "should create a new User instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    invalidUser = User.new(@attr.merge(:name => ""))
    invalidUser.should_not be_valid
  end

  it "should require an email address" do
    invalidUser = User.new(@attr.merge(:email => ""))
    invalidUser.should_not be_valid
  end

  it "should reject really long names" do
    invalidUser = User.new(@attr.merge(:name => ("a" * 51)))
    invalidUser.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      validUser = User.new(@attr.merge(:email => address))
      validUser.should be_valid
    end
  end   

  it "should reject invalid email addresses" do
    addresses = %w[ser@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalidUser = User.new(@attr.merge(:email => address))
      invalidUser.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    User.create!(@attr)
    invalidUser = User.new(@attr)
    invalidUser.should_not be_valid
  end

  it "should reject user w/ an identical email but just in upper case" do
    upcaseEmail = @attr[:email].upcase
    invalidUser = User.new(@attr.merge(:email => upcaseEmail))
    invalidUser.should_not be_valid
  end
  

 
  
end
