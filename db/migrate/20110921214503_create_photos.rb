class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.integer :page_id
      t.string :file

      t.timestamps
    end
    add_index :photos, :page_id
  end
end
