require 'spec_helper'

feature 'users' do
  context 'as a guest' do
    scenario 'listing' do
      visit('/users')
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
    background do
      @user = Factory(:user, :name => 'James Bond')
      login_as Factory(:admin)
    end
    
    scenario 'listing' do
      visit('/users')
      page.should have_css('table tr td a', :text => 'Show', :count => 2)
      page.should have_css('table tr td a', :text => 'Edit', :count => 2)
      page.should have_css('table tr td a', :text => 'Destroy', :count => 2)
    end
    
    scenario 'editing' do
      visit('/users')
      click_link('Edit')
      page.should have_content('Editing user')
      find_field('Name').value.should eq('James Bond')
    end
      
    scenario 'updating with valid data' do
      visit('/users')
      click_link('Edit')
      within('form') do
        fill_in 'Name', :with => 'Changed'
        click_button 'Update'
      end
      page.should have_content('User was successfully updated')
      expect { @user.reload }.to change{ @user.name }
    end
    
    scenario 'updating with invalid data' do
      visit('/users')
      click_link('Edit')
      within('form') do
        fill_in 'Name', :with => ''
        click_button 'Update'
      end
      page.should have_content('1 error prohibited this user from being saved')
      expect { @user.reload }.to_not change{ @user.name }
    end
    
    scenario 'destroying' do
      visit('/users')
      click_link('Destroy')
      page.should have_content('User was successfully destroyed')
      expect { @user.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
