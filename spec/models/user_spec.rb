require 'spec_helper'

describe User do

  before(:each) do
    @attr = { 
      :name => "Example User", 
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
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
    User.create!(@attr.merge(:email => upcaseEmail))
    invalidUser = User.new(@attr.merge(:email => upcaseEmail))
    invalidUser.should_not be_valid
  end
  
  describe "password validations" do
    it "should require a password" do
      invalidUser = User.new(@attr.merge(:password => "", :password_confirmation => ""))
      invalidUser.should_not be_valid
    end
    
    it "should require a matching password validation" do
      invalidUser = User.new(@attr.merge(:password_confirmation => "invalid"))
      invalidUser.should_not be_valid
    end
    
    it "should reject short passwords" do
      short = "a" * 5
      invalidUser = User.new(@attr.merge(:password => short, :password_confirmation => short))
      invalidUser.should_not be_valid
    end
    
    it "should reject long passwords" do
      long = "a" * 41
      invalidUser = User.new(@attr.merge(:password => long, :password_confirmation => long))
      invalidUser.should_not be_valid
    end
  end

  describe "password encryption" do
    before(:each) do
      @user = User.create!(@attr)
    end
    
    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should have a non-empty encrypted password" do
      @user.encrypted_password.should_not be_blank
    end

    describe "User::has_password class method" do
      it "should be true if passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end

      it "should be false if passwords don't match" do
        @user.has_password?("invalid").should be_false
      end
    end

    describe "User::authenticate(email,pass) static class method" do
      it "should return nil on email/password mismatch" do
        User.authenticate(@attr[:email],"wrongpass").should be_nil
      end
      
      it "should return nil for an email address with no user" do
        User.authenticate("bar@foo.com", @attr[:password]).should be_nil
      end
      
      it "should return the user on email/password match" do
        matchingUser = User.authenticate(@attr[:email], @attr[:password])
        matchingUser.should == @user
      end
    end
  end  
end
