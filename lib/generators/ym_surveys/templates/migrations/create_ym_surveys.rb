class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.string :name
      t.text :description
      t.string :image_uid
      t.text :email_text
      t.text :thanks_url
      t.boolean :can_take_multiple, :default => false

      t.timestamps
    end
  end
end
