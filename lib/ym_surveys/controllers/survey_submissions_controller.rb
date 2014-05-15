module YmSurveys::SurveySubmissionsController

  def self.included(base)
    base.load_and_authorize_resource
  end

  def create
    @submission = SurveySubmission.new(params[:survey_submission].merge({:user_id => current_user.id}))
    if @submission.is_valid?
      if @submission.last_step?
        @submission.save
        SurveyMailer.survey_completed(@submission, current_user).deliver if @submission.survey.email_text.present?
        redirect_to survey_thanks_path
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
    @survey_submissions = SurveySubmission.where(:survey_id => params[:survey_id]).sort_by(&:created_at)
    respond_to do |format|
      format.html
      format.csv { send_data SurveySubmission.to_csv(params[:survey_id]), :filename => "#{@survey_submissions.first.survey.name}.csv" }
    end
  end

  def show
    @submission = SurveySubmission.find params[:id]
  end

end
