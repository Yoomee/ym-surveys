class CreateYmSurveyQuestionGroups < ActiveRecord::Migration
  def change
    create_table :survey_question_groups do |t|
      t.string :heading
      t.text :heading_text
      t.int  :position
      t.references :survey, :index => true

      t.timestamps
    end
  end
end
