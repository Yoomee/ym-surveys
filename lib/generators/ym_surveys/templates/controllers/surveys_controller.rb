class SurveysController < ApplicationController
  include YmSurveys::SurveysController

  private
  def permitted_survey_parameters
    [
      :description,
      :name,
      :image,
      :remove_image,
      :retained_image,
      :thanks_url,
      question_groups_attributes:
        [
          :heading,
          :heading_text,
          :position,
          :dependence_logic,
          questions_attributes: [
             '_destroy',
             :name,
             :position,
             :field_type,
             :required,
             :default_to,
             :help_text,
             options: []
          ]
        ]
     ]
  end

end
