module YmSurveys::SurveyQuestionResponse

  def self.included(base)
    base.belongs_to :survey_submission
    base.belongs_to :survey_question
    base.send(:serialize, :response)
    base.validates :response, :presence => true, :if => :required?
    base.delegate :required?, :to => :survey_question
    base.send(:before_save, :reject_empty_array_items)
  end

  private
  def reject_empty_array_items
    response.reject!(&:empty?) if response.is_a?(Array)
  end

end
