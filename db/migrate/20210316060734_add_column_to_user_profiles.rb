class AddColumnToUserProfiles < ActiveRecord::Migration[5.2]
  tag :predeploy
  def change
    add_column :user_profiles, :field_of_specialization, :string
    add_column :user_profiles, :background_info_on_the_mentor, :text
    add_column :user_profiles, :project_for_mentees, :string
  end
end
