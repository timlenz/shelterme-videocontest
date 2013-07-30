class AddMoreInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :date_of_birth, :datetime
    add_column :users, :phone, :string
    add_column :users, :zipcode, :string
    add_column :users, :street, :string
    add_column :users, :state, :string
  end
end
