module YmSurveys::Survey

  def self.included(base)
    base.send(:attr_accessible, :description, :name)
    base.has_many :question_groups, :class_name => 'SurveyQuestionGroup', :dependent => :destroy, :order => :position
    base.has_many :submissions, :class_name => 'SurveySubmission', :dependent => :destroy
    base.has_permalinks
    base.image_accessor :image
  end

end
