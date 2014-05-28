module YmSurveys::SurveyQuestionResponse

  def self.included(base)
    base.belongs_to :survey_submission
    base.belongs_to :survey_question
    base.send(:serialize, :response)
    base.validates :response, :presence => true, :if => :required?
    base.validates :response, :email => true, :if => Proc.new{|r| r.survey_question.field_format == 'email'}
    base.validates :response, :format => {:with => /^[a-zA-Z0-9_\s+]*$/}, :if => Proc.new{|r| %w[phone_number postcode].include?(r.survey_question.field_format)}
    base.validates_numericality_of :response, :if => Proc.new{|r| r.survey_question.field_format == 'age'}
    base.delegate :required?, :to => :survey_question
    base.send(:before_save, :reject_empty_array_items)
  end

  private
  def reject_empty_array_items
    response.reject!(&:empty?) if response.is_a?(Array)
  end

end
