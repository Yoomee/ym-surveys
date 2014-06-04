module YmSurveys::SurveySubmission
  include YmCore::Multistep

  def self.included(base)
    base.belongs_to :survey
    base.belongs_to :user
    base.has_many :survey_question_responses
    base.send(:accepts_nested_attributes_for, :survey_question_responses)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def to_csv(survey_id)
      survey = Survey.find(survey_id)
      column_names = ["timestamp", "First Name", "Last Name", "E-mail", "DOB"] + survey.question_groups.map { |x| x.questions.map(&:name) }.flatten
      CSV.generate do |csv|
        csv << column_names
        survey.submissions.each do |submission|
          standard_fields = []
          standard_fields << submission.created_at
          standard_fields << submission.user.first_name
          standard_fields << submission.user.last_name
          standard_fields << submission.user.email
          standard_fields << submission.user.dob.strftime("%d/%m/%Y")
          csv << standard_fields + submission.survey_question_responses.map {|x| [*x.response].join("\n") }
        end
      end
    end
  end

  def build_responses
    survey.question_groups.each do |question_group|
      question_group.questions.each do |question|
        if question.default_to
          question.update_attribute(:field_format, question.default_to)
          default_value = question.get_default(self.user) || nil
        end
        self.survey_question_responses.build(:survey_question_id => question.id, :response => default_value)
      end
    end
  end

  def current_step=(value)
    @current_step = value.to_i
  end

  def current_step_index
    steps.index(current_step) + 1
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

  def user
    if current_step == 1
      return super if super.present?
    end
    first_name_question_id = SurveyQuestion.find_by_default_to("first_name").id
    last_name_question_id = SurveyQuestion.find_by_default_to("last_name").id
    email_question_id = SurveyQuestion.find_by_default_to("email").id
    dob_question_id = SurveyQuestion.find_by_default_to("dob").id
    first_name = self.survey_question_responses.select{ |x| x.survey_question_id == first_name_question_id }.first.try(:response)
    last_name = self.survey_question_responses.select{ |x| x.survey_question_id == last_name_question_id }.first.try(:response)
    email = self.survey_question_responses.select{ |x| x.survey_question_id == email_question_id }.first.try(:response)
    dob = self.survey_question_responses.select{ |x| x.survey_question_id == dob_question_id }.first.try(:response)


    User.new(:first_name => first_name, :last_name => last_name, :email => email, :dob => dob)
  end


end
