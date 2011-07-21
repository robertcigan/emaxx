class AddHtmlContentToPages < ActiveRecord::Migration
  def change
    add_column :pages, :html_content, :text
  end
end
