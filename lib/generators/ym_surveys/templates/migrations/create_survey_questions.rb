class CreateSurveyQuestions < ActiveRecord::Migration
  def change
    create_table :survey_questions do |t|
      t.string :name
      t.integer :position
      t.text :help_text
      t.string :field_type
      t.string :field_format
      t.text :options
      t.boolean :required, :default => false
      t.string :default_to

      t.references :survey_question_group, :index => true

      t.timestamps
    end
  end
end
