module YmSurveys::SurveySubmission
  include YmCore::Multistep

  def self.included(base)
    base.belongs_to :survey
    base.belongs_to :user
    base.has_many :survey_question_responses
    base.send(:accepts_nested_attributes_for, :survey_question_responses)
  end

  def build_responses
    survey.question_groups.each do |question_group|
      question_group.questions.each do |question|
        if question.default_to
          default_value = question.get_default(self.user) || nil
        end
        self.survey_question_responses.build(:survey_question_id => question.id, :response => default_value)
      end
    end
  end

  def current_step=(value)
    @current_step = value.to_i
  end

  def steps
    survey.question_groups.map{ |x| x.id }
  end

  def is_valid?
    questions_to_validate = SurveyQuestionGroup.find(current_step).questions.map{|x| x.id}
    survey_question_responses.each do |response|
      if questions_to_validate.include?(response.survey_question_id) && !response.valid?
        return false
      end
    end
  end

end
