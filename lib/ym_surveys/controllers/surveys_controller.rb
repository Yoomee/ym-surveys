module YmSurveys::SurveysController

  def self.included(base)
    base.load_and_authorize_resource
  end

  def show
    @survey = Survey.find(params[:id])
    @submission ||= @survey.submissions.build(:user => current_user)
    @submission.build_responses
    @question_group = SurveyQuestionGroup.find @submission.current_step
  end

  def index
    @surveys = Survey.all
  end
end
