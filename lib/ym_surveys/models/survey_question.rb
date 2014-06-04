module YmSurveys::SurveyQuestion

  def self.included(base)
    base.send(:attr_accessible, :name, :field_type, :options, :required, :default_to, :help_text)
    base.send(:serialize, :options)
    base.belongs_to :survey_question_group
  end

  def get_default(user)
    if default_to.nil? || user.nil? then return end
    user.send(default_to)
  end
end