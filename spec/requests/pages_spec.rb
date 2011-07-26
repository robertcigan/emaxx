require 'spec_helper'

feature "pages" do
  background do
    @page = Factory(:page, :title => 'Happy Easter', :content => 'Bunny the Rabbit is somewhere in your garden')
  end
  
  context 'as a guest' do
    context 'listing' do
      scenario 'all pages' do
        visit('/pages')
        current_path.should eq('/pages')
        page.should have_css('strong', :text => 'Happy Easter')
        page.should have_no_link('New Page')
      end
      
      scenario 'by a tag' do
        Factory(:page, :title => 'Page1', :tag_list => 'tag1, tag2')
        Factory(:page, :title => 'Page2', :tag_list => 'tag1')
        Factory(:page, :title => 'Page3', :tag_list => 'tag3')
        visit('/tag/tag1')
        page.should have_css(:strong, :text => 'Page1')
        page.should have_css(:strong, :text => 'Page2')
        page.should have_no_css(:strong, :text => 'Page3')
      end
      
      scenario 'shows tag cloud' do
        Factory(:page, :tag_list => 'tag1')
        Factory(:page, :tag_list => 'tag2')
        Factory(:page, :tag_list => 'tag3')
        visit('/pages')
        within('.tag-cloud') do
          page.should have_link('tag1')
          page.should have_link('tag2')
          page.should have_link('tag3')
        end
      end
      
      scenario 'has pagination' do
        25.times { Factory(:page) }
        visit('/pages')
        within('nav.pagination') do
          page.should have_css('span.current')
          page.should have_link('2')
          page.should have_link('Next')
        end
      end
    end
    
    context 'showing the page' do
      scenario 'has no manage links for user' do
        visit('/pages/happy-easter')
        within('div.content') do
          page.should have_no_link('Edit')
          page.should have_no_link('Destroy')
          page.should have_link('news')
          page.should have_link('worldwide')
        end
      end
      
      scenario 'has tag links' do
        visit('/pages/happy-easter')
        within('div.content') do
          page.should have_link('news')
          page.should have_link('worldwide')
        end
      end
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
      page.should have_no_link('New Page')
    end
    
    context 'showing the page' do
      scenario 'has no manage links for user' do
        visit('/pages/happy-easter')
        within('div.content') do
          page.should have_no_link('Edit')
          page.should have_no_link('Destroy')
          page.should have_link('news')
          page.should have_link('worldwide')
        end
      end
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
      find_field('Tag list').value.should eq('news, worldwide')
      find_field('page_publish_at_1i').value.should eq('2010')
      find_field('Content').value.should eq('Bunny the Rabbit is somewhere in your garden')
    end
      
    scenario 'updating with valid data' do
      visit('/pages')
      click_link('Edit')
      within('form') do
        fill_in 'Title', :with => 'Changed'
        select('2011', :from => 'page_publish_at_1i')
        fill_in('Tag list', :with => 'changed')
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
end
