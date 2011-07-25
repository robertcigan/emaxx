require 'spec_helper'

feature "pages" do
  background do
    @page = Factory(:page, :title => 'Happy Easter', :content => 'Bunny the Rabbit is somewhere in your garden')
  end
  
  context 'as a guest' do
    scenario 'listing' do
      visit('/pages')
      current_path.should eq('/pages')
      page.should have_css('strong', :text => 'Happy Easter')
    end
  end
  
  context 'as a user' do
    background do
      login_as Factory(:user)
    end
    
    scenario 'listing' do
      visit('/pages')
      current_path.should eq('/pages')
      page.should have_css('strong', :text => 'Happy Easter')
    end
  end
  
  context 'as an admin' do
    background do
      Factory(:page)
      login_as Factory(:admin)
    end
    
    scenario 'listing' do
      visit('/pages')
      current_path.should eq('/pages')
      page.should have_css('strong', :text => 'Happy Easter')
      page.should have_link('New Page')
    end
    
    scenario 'editing' do
      visit('/pages')
      click_link('Edit')
      page.should have_content('Editing page')
      find_field('Title').value.should eq('Happy Easter')
      find_field('page_publish_at_1i').value.should eq('2010')
      find_field('Content').value.should eq('Bunny the Rabbit is somewhere in your garden')
    end
      
    scenario 'updating with valid data' do
      visit('/pages')
      click_link('Edit')
      within('form') do
        fill_in 'Title', :with => 'Changed'
        select('2011', :from => 'page_publish_at_1i')
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
      visit('/pages/happy-easter')
      click_link('Destroy')
      page.should have_content('Page was successfully destroyed')
      expect { @page.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
    
    context 'showing page' do
      scenario 'has manage links for admin' do
        visit('/pages/happy-easter')
        within('div.content') do
          page.should have_link('Edit')
          page.should have_link('Destroy')
        end
      end
    end
  end
  
  context 'as a user' do
    background do
      @page = Factory(:page, :title => 'Happy Easter')
      Factory(:page)
      login_as Factory(:admin)
    end
    
    context 'showing page' do
      scenario 'has no manage links for user' do
        login_as(Factory(:user, :email => 'user@example.com'))
        visit('/pages/happy-easter')
        within('div.content') do
          page.should have_no_link('Edit')
          page.should have_no_link('Destroy')
        end
      end
      
      scenario 'has manage links for admin' do
        visit('/pages/happy-easter')
        within('div.content') do
          page.should have_link('Edit')
        end
      end

      scenario 'showing page' do
        visit('/pages/happy-easter')
        within('div.content') do
          page.should have_css('h1', :text => 'Happy Easter')
          page.should have_content("Bunny the Rabbit is somewhere in your garden")
        end
      end
    end
  end
  
end
