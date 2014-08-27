module YmSurveys::Survey

  def self.included(base)
    base.send(:attr_accessible, :description, :name, :image, :remove_image, :retained_image, :question_groups_attributes, :thanks_url)
    base.has_many :question_groups, :class_name => 'SurveyQuestionGroup', :dependent => :destroy, :order => :position
    base.has_many :submissions, :class_name => 'SurveySubmission', :dependent => :destroy
    base.has_permalinks
    base.image_accessor :image
    base.accepts_nested_attributes_for :question_groups, :allow_destroy => true
  end

end
