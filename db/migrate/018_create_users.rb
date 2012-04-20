class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
    t.column :login, :string
    t.column :email, :string
    t.column :password, :string
    t.column :usertype, :string
    t.column :userstatus, :char
    t.column :loginstatus, :char, :default=>'N'
    t.column :counterno, :int, :default=>0
    t.column :firstname, :string
    t.column :lastname, :string
    t.column :created_on, :date
    t.column :updated_on, :date
 

    end
      User.create(:login => 'admin',
  :password => 'sprylogic',
  :password_confirmation => 'sprylogic',
  :usertype=>'admin',
  :userstatus=>'1',
  :loginstatus=>'N',
  :firstname => 'uttara',
  :lastname => 'mandge',
  :email => 'mandge_uttara@yahoo.com'
  )

  end  
  
  def self.down
    drop_table :users
  end
end
