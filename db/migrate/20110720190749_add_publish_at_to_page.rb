class AddPublishAtToPage < ActiveRecord::Migration
  def change
    add_column :pages, :publish_at, :datetime
  end
end
