module YmSurveys::SurveySubmission
  include YmCore::Multistep

  def self.included(base)
    base.belongs_to :survey
    base.belongs_to :user
    if Rails::VERSION::MAJOR >= 4
      base.has_many :survey_question_responses, -> { joins(:survey_question).order('survey_questions.position') }, dependent: :destroy
    else
      base.has_many :survey_question_responses, dependent: :destroy
    end
    base.send(:accepts_nested_attributes_for, :survey_question_responses)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def to_csv(survey_id)
      survey = Survey.find(survey_id)
      column_names = ["timestamp", "submission id"] + survey.question_groups.map { |x| x.questions.map(&:name) }.flatten
      question_ids_in_order = survey.question_groups.map{|g| g.question_ids}.flatten
      CSV.generate do |csv|
        csv << column_names
        survey.submissions.each do |submission|
          standard_fields = []
          standard_fields << submission.created_at
          standard_fields << submission.id
          csv << standard_fields + submission.survey_question_responses.sort{|x,y| question_ids_in_order.index(x.survey_question_id) <=> question_ids_in_order.index(y.survey_question_id)}.map {|x| [*x.response].join("\n") }
        end
      end
    end
  end

  def build_responses
    survey.question_groups.each do |question_group|
      question_group.questions.each do |question|
        if !question.default_to.try(:empty?)
          if Rails::VERSION::MAJOR >= 4
            question.assign_attributes({:field_format => question.default_to})
          else
            question.assign_attributes({:field_format => question.default_to}, :without_protection => true)
          end
          default_value = question.get_default(self.user) || nil
        end
        self.survey_question_responses.build(:survey_question_id => question.id, :response => default_value)
      end
    end
  end

  def next_step
    question_group = SurveyQuestionGroup.find steps[steps.index(current_step)+1]
    if question_group.dependence_logic.present?
      d = question_group.dependence_logic.split /#/
      question_response = survey_question_responses.select {|x| x.response == d[1] && x.survey_question.name == d[0] }
      if question_response.blank?
        return steps[steps.index(current_step)+2] || "-1"
      end
    end
    super
  end

  def current_step=(value)
    @current_step = value.to_i
  end

  def current_step_index
    steps.index(current_step) + 1
  end

  def steps
    survey.question_groups.order(:position).map{ |x| x.id }
  end

  def is_valid?
    questions_to_validate = ::SurveyQuestionGroup.find(current_step).questions.map{|x| x.id}
    survey_question_responses.each do |response|
      if questions_to_validate.include?(response.survey_question_id) && !response.valid?
        return false
      end
    end
  end

end
