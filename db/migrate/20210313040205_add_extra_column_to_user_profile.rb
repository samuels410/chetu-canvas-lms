class AddExtraColumnToUserProfile < ActiveRecord::Migration[5.2]
  tag :predeploy
  def change
    add_column :user_profiles, :phone, :string
    add_column :user_profiles, :member_type, :string
    add_column :user_profiles, :geographic_location, :string
    add_column :user_profiles, :speciality_focus, :string
    add_column :user_profiles, :major, :string
    add_column :user_profiles, :race, :string
    add_column :user_profiles, :ethnicity, :string
    add_column :user_profiles, :sexual_orientation, :string
    add_column :user_profiles, :first_generation, :string
    add_column :user_profiles, :second_generation, :string
    add_column :user_profiles, :gender, :string
    add_column :user_profiles, :disability_status, :string
    add_column :user_profiles, :income_status, :string
    add_column :user_profiles, :immigration_status, :string
    add_column :user_profiles, :areas_of_interest, :string
  end
end
