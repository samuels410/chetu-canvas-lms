class AddFieldsToUserProfile < ActiveRecord::Migration[6.0]
  tag :predeploy
  def change
    add_column :user_profiles, :important_to_me, :string
    add_column :user_profiles, :about_me, :text
    add_column :user_profiles, :professional_interests_experiences, :string
    add_column :user_profiles, :professional_goal, :string
    add_column :user_profiles, :permanent_address, :string
  end
end
