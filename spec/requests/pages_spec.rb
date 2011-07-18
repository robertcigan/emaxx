require 'spec_helper'

feature "pages" do
  context 'as a guest' do
    scenario 'listing' do
      visit('/pages')
      current_path.should eq('/users/sign_in')
    end
  end
  
  context 'as a page' do
    background do
      login_as Factory(:user)
    end
    
    scenario 'listing' do
      visit('/pages')
      page.should have_content 'You are not authorized to access this page.'
    end
  end
  
  context 'as an admin' do
    background do
      @page = Factory(:page, :title => 'Happy Easter')
      Factory(:page)
      login_as Factory(:admin)
    end
    
    scenario 'listing' do
      visit('/pages')
      page.should have_css('table tr td a', :text => 'Show', :count => 2)
      page.should have_css('table tr td a', :text => 'Edit', :count => 2)
      page.should have_css('table tr td a', :text => 'Destroy', :count => 2)
    end
    
    scenario 'editing' do
      visit('/pages')
      click_link('Edit')
      page.should have_content('Editing page')
      find_field('Title').value.should eq('Happy Easter')
    end
      
    scenario 'updating with valid data' do
      visit('/pages')
      click_link('Edit')
      within('form') do
        fill_in 'Title', :with => 'Changed'
        click_button 'Update'
      end
      page.should have_content('Page was successfully updated')
      expect { @page.reload }.to change{ @page.title }
    end
    
    scenario 'updating with invalid data' do
      visit('/pages')
      click_link('Edit')
      within('form') do
        fill_in 'Title', :with => ''
        click_button 'Update'
      end
      page.should have_content('1 error prohibited this page from being saved')
      expect { @page.reload }.to_not change{ @page.title }
    end
    
    scenario 'destroying' do
      visit('/pages')
      click_link('Destroy')
      page.should have_content('Page was successfully destroyed')
      expect { @page.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
