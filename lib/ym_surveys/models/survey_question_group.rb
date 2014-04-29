module YmSurveys::SurveyQuestionGroup

  def self.included(base)
    base.belongs_to :survey
    base.has_many :questions, :class_name => 'SurveyQuestion', :dependent => :destroy
  end

end