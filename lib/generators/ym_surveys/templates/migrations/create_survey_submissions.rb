class CreateSurveySubmissions < ActiveRecord::Migration
  def change
    create_table :survey_submissions do |t|
      t.references :user, index: true
      t.references :survey, index: true

      t.timestamps
    end
  end
end
