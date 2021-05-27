class AddMentorFieldsToUserProfile < ActiveRecord::Migration[6.0]
  tag :predeploy
  def change
  	add_column :user_profiles, :first_name, :string
  	add_column :user_profiles, :last_name, :string
    add_column :user_profiles, :mentor_project, :text
    add_column :user_profiles, :mentor_first_name, :string
    add_column :user_profiles, :mentor_last_name, :string
    add_column :user_profiles, :mentor_email, :string
    add_column :user_profiles, :mentor_phone, :string
  end
end
