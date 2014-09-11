class SurveySubmissionsController < ApplicationController
  include YmSurveys::SurveySubmissionsController

  private
  def permitted_survey_submission_parameters
    [
      :survey_id,
      :current_step,
      survey_question_responses_attributes: [
        :survey_question_id,
        :response,
        :survey_question_id
      ]
    ]
  end

end
