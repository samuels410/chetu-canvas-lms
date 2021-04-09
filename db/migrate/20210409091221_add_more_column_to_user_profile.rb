class AddMoreColumnToUserProfile < ActiveRecord::Migration[6.0]
  tag :predeploy
  def change
  	add_column :user_profiles, :strength_weakness, :string
    add_column :user_profiles, :affiliation, :text
  end
end
