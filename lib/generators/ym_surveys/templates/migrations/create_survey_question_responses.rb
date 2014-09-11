class CreateSurveyQuestionResponses < ActiveRecord::Migration
  def change
    create_table :survey_question_responses do |t|
      t.text :response

      t.references :survey_question, :index => true
      t.references :survey_submission, :index => true

      t.timestamps
    end
  end
end
