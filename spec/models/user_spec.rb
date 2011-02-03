require 'spec_helper'

describe User do

	before(:each) do
		@validUserAttr = { 
			:name => "daniel", 
			:email => "test@test.com",
			:password => "secret",
			:confirm_password => "secret"
			}
	end
	
	it "should create new instance" do
		User.create!(@validUserAttr)
	end
	
	it "should require a name" do
		no_name_user = User.new(@validUserAttr.merge(:name => ""))
		no_name_user.should_not be_valid		
	end
	
	it "should require a email" do
		no_name_user = User.new(@validUserAttr.merge(:email => ""))
		no_name_user.should_not be_valid		
	end

	it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_user = User.new(@validUserAttr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end
  
  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@validUserAttr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end
  
  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@validUserAttr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end
  
  it "should reject duplicate email addresses" do
    # Put a user with given email address into the database.
    User.create!(@validUserAttr)
    user_with_duplicate_email = User.new(@validUserAttr)
    user_with_duplicate_email.should_not be_valid
  end
  
   it "should reject email addresses identical up to case" do
    upcased_email = @validUserAttr[:email].upcase
    User.create!(@validUserAttr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@validUserAttr)
    user_with_duplicate_email.should_not be_valid
  end

	describe "password  validations" do
		
		it "should require a password" do
			user = User.new(@validUserAttr.merge(:password => "", :password_confirmation => ""))
			user.should_not be_valid			
		end
		
		 it "should require a matching password confirmation" do
      User.new(@validUserAttr.merge(:password => "secret", :password_confirmation => "invalid")).
        should_not be_valid
    end

    it "should reject short passwords" do
      short = "a" * 5
      hash = @validUserAttr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end

    it "should reject long passwords" do
      long = "a" * 41
      hash = @validUserAttr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end

		
	end
	
	describe "password encryption" do

    before(:each) do
      @user = User.create!(@validUserAttr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end
    
    it "should not have a blank encrypted password" do
    	@user.encrypted_password.should_not be_blank    	
    end
    
		describe "has_password? method" do

      it "should be true if the passwords match" do
        @user.has_password?(@validUserAttr[:password]).should be_true
      end    

      it "should be false if the passwords don't match" do
        @user.has_password?("invalid").should be_false
      end 
    end
    
    describe "authenticate method" do

      it "should return nil on email/password mismatch" do
        wrong_password_user = User.authenticate(@validUserAttr[:email], "wrongpass")
        wrong_password_user.should be_nil
      end

      it "should return nil for an email address with no user" do
        nonexistent_user = User.authenticate("bar@foo.com", @validUserAttr[:password])
        nonexistent_user.should be_nil
      end

      it "should return the user on email/password match" do
        matching_user = User.authenticate(@validUserAttr[:email], @validUserAttr[:password])
        matching_user.should == @user
      end
    end

    
  end


	describe "admin attribute" do

    before(:each) do
      @user = User.create!(@validUserAttr)
    end

    it "should respond to admin" do
      @user.should respond_to(:admin)
    end

    it "should not be an admin by default" do
      @user.should_not be_admin
    end

    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end



end
