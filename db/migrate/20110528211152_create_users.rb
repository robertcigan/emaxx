class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string        :email,              :null => false
      t.boolean       :admin,                               :default => false
      t.string        :name,               :null => false
      t.string        :encrypted_password, :null => false,  :default => '', :limit => 128
      t.recoverable
      t.rememberable
      t.trackable
      t.confirmable
    end
          
    add_index :users, :name,                  :unique => true
    add_index :users, :email,                 :unique => true
    add_index :users, :admin
    add_index :users, :reset_password_token,  :unique => true
    add_index :users, :confirmation_token,    :unique => true
  end

  def self.down
    drop_table :users
  end
end
