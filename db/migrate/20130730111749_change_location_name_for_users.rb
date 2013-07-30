class ChangeLocationNameForUsers < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.rename :location, :city
    end
  end

  def down
    change_table :users do |t|
      t.rename :city, :location
    end
  end
end
