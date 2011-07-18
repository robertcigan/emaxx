require 'spec_helper'

describe User do
  before do
    @user = Factory(:user)
  end
  
  describe 'validation' do
    describe 'of name' do
      it 'requires to be present' do
        user = Factory.build(:user, :name => nil)
        user.should have(1).error_on(:name)
      end
      
      it 'requires to be uniq' do
        user = Factory.build(:user, :name => @user.name)
        user.should have(1).error_on(:name)
      end
    end
    
    describe 'of email' do
      it 'requires to be present' do
        user = Factory.build(:user, :email => nil)
        user.should have(1).error_on(:email)
      end
      
      it 'requires to have a email format' do
        user = Factory.build(:user, :email => "not a valid email address")
        user.should have(1).error_on(:email)
      end
      
      it 'requires to be uniq' do
        user = Factory.build(:user, :email => @user.email)
        user.should have(1).error_on(:email)
      end
    end
  end
  
  describe 'mass assigment protection' do
    it 'allows name' do
      @user.attributes = { :name => 'changed' }
      expect { @user.reload }.to change{ @user.name }
    end
    
    it 'allows email' do
      @user.attributes = { :email => 'changed@example.com' }
      expect { @user.reload }.to change{ @user.email }
    end
    
    it 'does not allow admin' do
      @user.attributes = { :admin => true }
      expect { @user.reload }.to_not change{ @user.admin }
    end
    
    it 'allows password' do
      @user.attributes = { :password => 'secretsecret' }
      @user.password.should eq('secretsecret')
    end
    
    it 'allows password confirmation' do
      @user.attributes = { :password_confirmation => 'secretsecret' }
      @user.password_confirmation.should eq('secretsecret')
    end
  end
end
