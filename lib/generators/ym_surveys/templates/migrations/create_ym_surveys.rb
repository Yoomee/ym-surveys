class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.string :name
      t.text :description
      t.string :image_uid
      t.text :email_text

      t.timestamps
    end
  end
end
