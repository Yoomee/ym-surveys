module YmSurveys::SurveySubmissionsController

  def create
    @submission = SurveySubmission.new(params[:survey_submission].merge({:user_id => current_user.id}))

    if @submission.is_valid?
      if @submission.last_step?
        @submission.save
        flash[:notice] = "Thank you for filling in #{@submission.survey.name}"
        redirect_to("/team-v")
      else
        @submission.next_step!
        @question_group = SurveyQuestionGroup.find @submission.current_step
        render :template => 'surveys/show'
      end
    else
      @question_group = SurveyQuestionGroup.find @submission.current_step
      render :template => 'surveys/show'
    end
  end

  def index
    @survey_submissions = SurveySubmission.where(:survey_id => params[:survey_id])
  end

  def show
    @submission = SurveySubmission.find params[:id]
  end

end
