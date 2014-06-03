module YmSurveys::SurveyQuestionGroup

  def self.included(base)
    base.send(:attr_accessible, :heading, :heading_text, :questions_attributes, :position)
    base.belongs_to :survey
    base.has_many :questions, :class_name => 'SurveyQuestion', :dependent => :destroy
  end

end