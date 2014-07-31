$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ym_surveys/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ym_surveys"
  s.version     = YmSurveys::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of YmSurveys."
  s.description = "TODO: Description of YmSurveys."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency 'rails', '~> 3.2.13'
  s.add_dependency 'ym_core', '~> 1.1.4'
  s.add_dependency 'ym_permalinks', '~> 1.0.3'
  s.add_dependency 'cocoon'

  s.add_development_dependency "sqlite3"
end
