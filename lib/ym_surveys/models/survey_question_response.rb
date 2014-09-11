module YmSurveys::SurveyQuestionResponse

  def self.included(base)
    base.belongs_to :survey_submission
    base.belongs_to :survey_question
    base.send(:serialize, :response)
    base.send(:file_accessor, :file)
    base.validates :response, :presence => true, :if => :required?
    base.validates :response, :email => true, :if => Proc.new{|r| r.survey_question.field_format == 'email'}
    base.validates :response, :format => {:with => /\A[a-zA-Z0-9_\s+]\z/}, :if => Proc.new{|r| %w[phone postcode].include?(r.survey_question.field_format)}
    base.validates_numericality_of :response, :if => Proc.new{|r| r.survey_question.field_format == 'age'}
    base.delegate :required?, :to => :survey_question
    # base.send(:before_save, :reject_empty_array_items)
  end

  # def dragonfly_attachments
  #   debugger
  #   if %{file image}.include?(survey_question.field_type)
  #     super
  #   else
  #     {}
  #   end
  # end

  def raw_value
    read_attribute(:response)
  end

  def response
    case survey_question.field_type
    when 'file'
      file
    else
      raw_value
    end
  end

  def file_uid
    read_attribute(:response)
  end

  def file_uid=(uid)
    self.response = uid
  end

  private
  def reject_empty_array_items
    response.reject!(&:empty?) if response.is_a?(Array)
  end

end
