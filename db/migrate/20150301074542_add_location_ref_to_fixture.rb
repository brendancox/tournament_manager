class AddLocationRefToFixture < ActiveRecord::Migration
  def change
  	add_column :fixtures, :location, :string
  	add_column :fixtures, :referee, :string
  end
end
