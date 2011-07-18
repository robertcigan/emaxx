require 'spec_helper'

feature 'registrations' do
  context 'as a guest' do
    scenario 'I have no access' do
      visit('/users/edit')
      current_path.should eq('/users/sign_in')
    end
  end
  
  context 'as a user' do
    background do
      login_as @user = Factory(:user, :name => 'James Bond')
    end
    
    scenario 'editing' do
      visit('/users/edit')
      click_link('Edit')
      page.should have_content('Edit User')
      find_field('Name').value.should eq('James Bond')
    end
      
    scenario 'updating with valid data' do
      visit('/users/edit')
      within('form') do
        fill_in 'Name', :with => 'Changed'
        fill_in 'Current password', :with => 'secret'
        click_button 'Update'
      end
      page.should have_content('You updated your account successfully')
      expect { @user.reload }.to change{ @user.name }
    end
    
    scenario 'updating with invalid data' do
      visit('/users/edit')
      within('form') do
        fill_in 'Name', :with => ''
        click_button 'Update'
      end
      page.should have_content('2 errors prohibited this user from being saved')
      expect { @user.reload }.to_not change{ @user.name }
    end
    
    scenario 'changing password with valid data' do
      visit('/users/edit')
      within('form') do
        fill_in 'Password', :with => 'SecretSecret'
        fill_in 'Password confirmation', :with => 'SecretSecret'
        fill_in 'Current password', :with => 'secret'
        click_button 'Update'
      end
      page.should have_content('You updated your account successfully')
      expect { @user.reload }.to change{ @user.encrypted_password }
    end
    
    scenario 'changing password with invalid data' do
      visit('/users/edit')
      within('form') do
        fill_in 'Password', :with => 'SecretSecret'
        fill_in 'Password confirmation', :with => 'WrongSecret'
        click_button 'Update'
      end
      page.should have_content('2 errors prohibited this user from being saved')
      expect { @user.reload }.to_not change{ @user.encrypted_password }
    end
    
    scenario 'cancel the account' do
      pending
      #visit('/users/edit')
      
      
    end
  end
end
