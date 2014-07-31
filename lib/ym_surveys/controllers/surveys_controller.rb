module YmSurveys::SurveysController

  def self.included(base)
    base.load_and_authorize_resource
  end

  def create
    @survey = Survey.new(params[:survey])
    @survey.save
    redirect_to @survey
  end

  def edit
  end

  def show
    if !@survey.can_take_multiple && current_user && !current_user.is_admin? && SurveySubmission.where(:user_id => current_user.id).count > 0
      redirect_to survey_already_taken_path(@survey)
    end
    @submission ||= @survey.submissions.build(:user => current_user)
    @submission.build_responses
    @question_group = SurveyQuestionGroup.find @submission.current_step
  end

  def index
    @surveys = Survey.all
  end

  def update
    if @survey.update_attributes(params[:survey])
      redirect_to @survey
    else
      render 'edit'
    end
  end

  def thanks
    @survey = Survey.find params[:survey_id]
    if @survey.thanks_url.present?
      redirect_to @survey.thanks_url
    else
      render "thanks"
    end
  end

  def already_taken
  end

  def new
    question_group = @survey.question_groups.build
    question_group.questions.build
  end
end
