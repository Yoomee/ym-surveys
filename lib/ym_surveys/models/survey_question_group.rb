module YmSurveys::SurveyQuestionGroup

  def self.included(base)
    base.belongs_to :survey
    if Rails::VERSION::MAJOR >= 4
    base.has_many :questions, -> { order 'position' }, :class_name => 'SurveyQuestion', :dependent => :destroy
    else
      base.has_many :questions, :class_name => 'SurveyQuestion', :dependent => :destroy, :order => :position
    end

    base.accepts_nested_attributes_for :questions, :allow_destroy => true
  end

end
