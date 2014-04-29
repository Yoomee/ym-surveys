module YmSurveys::SurveyQuestionResponse

  def self.included(base)
    base.belongs_to :survey_submission
    base.belongs_to :survey_question
    base.send(:serialize, :response)
    base.validates :response, :presence => true, :if => :required?
    base.delegate :required?, :to => :survey_question
  end
end
