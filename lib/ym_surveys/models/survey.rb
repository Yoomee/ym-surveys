module YmSurveys::Survey

  def self.included(base)
    if Rails::VERSION::MAJOR >= 4
      base.has_many :question_groups, -> { order 'position' }, :class_name => 'SurveyQuestionGroup', :dependent => :destroy
    else
      base.has_many :question_groups, :class_name => 'SurveyQuestionGroup', :dependent => :destroy, :order => :position
    end
    base.has_many :submissions, :class_name => 'SurveySubmission', :dependent => :destroy
    base.has_permalinks
    base.image_accessor :image
    base.accepts_nested_attributes_for :question_groups, :allow_destroy => true
  end

end
