class CreateUsersTable < ActiveRecord::Migration
  def change
  	create_table :users do |t|
  		t.string :email
  		t.string :user_name
  		t.string :password
  	end
  end
end
