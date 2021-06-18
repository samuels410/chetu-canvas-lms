class AddMentorSerialNoToUserDocument < ActiveRecord::Migration[6.0]
  tag :predeploy
  def change
  	add_column :user_documents, :mentor_serial_no, :string
  end
end
