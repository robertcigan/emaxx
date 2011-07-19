class AddCachedSlugToPages < ActiveRecord::Migration
  def change
    add_column :pages, :cached_slug, :string
    add_index  :pages, :cached_slug, :unique => true
  end
end
