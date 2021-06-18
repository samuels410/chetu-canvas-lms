class CreateUserDocuments < ActiveRecord::Migration[6.0]
  tag :predeploy
  def change
    create_table :user_documents do |t|
      t.references :user_profile, foreign_key: true

      t.timestamps
    end
  end
end
