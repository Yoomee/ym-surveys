module YmSurveys::SurveysHelper

  def substitute_user_placeholders(text, user)
   text.gsub(/\{\{(\w+)\}\}/) { |x| user.send($1) if user }
  end

end