module YmSurveys::SurveyQuestion

  def self.included(base)
    base.send(:serialize, :options)
    base.belongs_to :survey_question_group
  end

  def get_default(user)
    if default_to.nil? || default_to.empty? || user.nil? then return end
    default_value = user.send(default_to)
  end

  def field_type
    ActiveSupport::StringInquirer.new read_attribute(:field_type).to_s
  end

end
