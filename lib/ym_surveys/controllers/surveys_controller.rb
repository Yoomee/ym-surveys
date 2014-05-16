module YmSurveys::SurveysController

  def self.included(base)
    base.load_and_authorize_resource
  end

  def show
    if !@survey.can_take_multiple && current_user && SurveySubmission.where(:user_id => current_user.id).count > 0
      redirect_to survey_already_taken_path(@survey)
    end
    @submission ||= @survey.submissions.build(:user => current_user)
    @submission.build_responses
    @question_group = SurveyQuestionGroup.find @submission.current_step
  end

  def index
    @surveys = Survey.all
  end

  def thanks
  end

  def already_taken
  end
end
