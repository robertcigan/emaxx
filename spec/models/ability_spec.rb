require 'spec_helper'
require 'cancan/matchers'

describe Ability do
  describe "admin" do
    before do
      @ability = Ability.new(Factory(:admin))
    end

    it "manages users" do
      @ability.should be_able_to(:manage, User)
    end
  end

  describe "user" do
    before do
      @user = Factory(:user)
      @ability = Ability.new(@user)
    end

    it "does not read users" do
      @ability.should_not be_able_to(:read, User.new)
    end
    
    it 'does not manage users' do
      @ability.should_not be_able_to(:manage, User.new)
    end
    
  end
  
  describe 'guest' do
    before do
      @ability = Ability.new(nil)
    end

    it "does not read users" do
      @ability.should_not be_able_to(:read, User)
    end
    
    it "does not manage users" do
      @ability.should_not be_able_to(:manage, User)
    end
  end
end



