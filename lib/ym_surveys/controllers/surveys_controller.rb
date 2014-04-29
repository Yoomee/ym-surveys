module YmSurveys::SurveysController

  def show
    if current_user && current_user.admin?
      @survey = Survey.find(params[:id])
      @submission ||= @survey.submissions.build(:user => current_user)
      @submission.build_responses
      @question_group = SurveyQuestionGroup.find @submission.current_step
    else
      redirect_to root_path
    end
  end

  def index
    @surveys = Survey.all
  end
end
