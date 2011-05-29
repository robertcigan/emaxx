require 'spec_helper'

feature 'users' do
  context 'as a guest' do
    scenario 'listing' do
      visit users_path
      current_path.should eq('/users/sign_in')
    end
  end
  
  context 'as a user' do
    background do
      login_as Factory(:user)
    end
    
    scenario 'listing' do
      visit('/users')
      page.should have_content 'You are not authorized to access this page.'
    end
  end
  
  context 'as an admin' do
    scenario 'listing'
    scenario 'editing '
    scenario 'updating with valid data'
    scenario 'updating with invalid data'
    scenario 'destroying'
  end
end
