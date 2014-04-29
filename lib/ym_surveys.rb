require 'ym_core'
require "ym_surveys/engine"

module YmSurveys
end

Dir[File.dirname(__FILE__) + '/ym_surveys/models/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/ym_surveys/controllers/*.rb'].each {|file| require file }
