class SurveyMailer < ActionMailer::Base
  add_template_helper(YmSurveys::SurveysHelper)
  default :from => "\"#{Settings.site_name}\" <#{Settings.site_email}>",
          :bcc => ["greg@yoomee.com"]

  def survey_completed(submission, user)
    @submission = submission
    @user = user
    mail(:to => @user.email, :subject => "Team v Leader")
  end
end
