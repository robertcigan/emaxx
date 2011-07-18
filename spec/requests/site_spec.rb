require 'spec_helper'

feature 'site' do
  context 'visiting homepage' do
    background do
      visit root_path
    end
    
    scenario 'displays header' do
      page.should have_css('h1')
    end
    
    scenario 'displays menu' do
      page.should have_css('menu li')
    end
    
    scenario 'displays content' do
      page.should have_css('div.content')
    end
  end
  
  context 'as a guest'
    scenario 'sees a sign in link' do
      visit root_path
      page.should have_link('Sign In')
      page.should_not have_link('Sign Out')
    end
  
  context 'as a user' do
    background do
      login_as Factory(:user)
    end
  
    scenario 'sees a sign out link' do
      visit root_path
      page.should have_link('Sign Out')
      page.should_not have_link('Sign In')
    end
    
    scenario 'sees a profile link' do
      visit root_path
      page.should have_link('Edit Account')
    end
  end
end
