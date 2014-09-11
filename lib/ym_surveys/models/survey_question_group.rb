module YmSurveys::SurveyQuestionGroup

  def self.included(base)
    base.belongs_to :survey
    base.has_many :questions, :class_name => 'SurveyQuestion', :dependent => :destroy
    base.accepts_nested_attributes_for :questions, :allow_destroy => true
  end

end
