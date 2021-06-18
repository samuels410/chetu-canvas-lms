class AddMultipleMentorToUserProfile < ActiveRecord::Migration[6.0]
  tag :predeploy
  def change
    add_column :user_profiles, :mentor_project_2, :text
    add_column :user_profiles, :mentor_first_name_2, :string
    add_column :user_profiles, :mentor_last_name_2, :string
    add_column :user_profiles, :mentor_email_2, :string
    add_column :user_profiles, :mentor_phone_2, :string
    add_column :user_profiles, :mentor_project_3, :text
    add_column :user_profiles, :mentor_first_name_3, :string
    add_column :user_profiles, :mentor_last_name_3, :string
    add_column :user_profiles, :mentor_email_3, :string
    add_column :user_profiles, :mentor_phone_3, :string
  end
end
