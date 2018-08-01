class CreateUploadedFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :uploaded_files do |t|
      t.string :name
      t.text :description
      t.references :user, foreign_key: true
      t.attachment :file

      t.timestamps
    end
  end
end
