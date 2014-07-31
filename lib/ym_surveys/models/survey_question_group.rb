module YmSurveys::SurveyQuestionGroup

  def self.included(base)
    base.send(:attr_accessible, :heading, :heading_text, :questions_attributes, :position, :dependence_logic)
    base.belongs_to :survey
    base.has_many :questions, :class_name => 'SurveyQuestion', :dependent => :destroy
    base.accepts_nested_attributes_for :questions, :allow_destroy => true
  end

end