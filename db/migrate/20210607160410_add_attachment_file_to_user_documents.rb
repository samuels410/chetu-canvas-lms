class AddAttachmentFileToUserDocuments < ActiveRecord::Migration[6.0]
  tag :predeploy
  def self.up
    change_table :user_documents do |t|
      t.attachment :file
    end
  end

  def self.down
    remove_attachment :user_documents, :file
  end
end
