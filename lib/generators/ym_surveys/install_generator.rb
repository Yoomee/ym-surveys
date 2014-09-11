module YmSurveys
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include YmCore::Generators::Migration

      source_root File.expand_path("../templates", __FILE__)
      desc "Installs YmSurveys."

      def manifest
        # models
        copy_file "models/survey.rb",                                              "app/models/survey.rb"
        copy_file "models/survey_submission.rb",                                   "app/models/survey_submission.rb"
        copy_file "models/survey_question.rb",                                     "app/models/survey_question.rb"
        copy_file "models/survey_question_group.rb",                               "app/models/survey_question_group.rb"
        copy_file "models/survey_question_response.rb",                            "app/models/survey_question_response.rb"

        # views

        # controllers
        copy_file "controllers/surveys_controller.rb",                               "app/controllers/surveys_controller.rb"
        copy_file "controllers/survey_submissions_controller.rb",                    "app/controllers/survey_submissions_controller.rb"

        # migrations
        try_migration_template "migrations/create_surveys.rb",                    "db/migrate/create_surveys.rb"
        try_migration_template "migrations/create_survey_questions.rb",           "db/migrate/create_survey_questions.rb"
        try_migration_template "migrations/create_survey_submissions.rb",         "db/migrate/create_survey_submissions.rb"
        try_migration_template "migrations/create_survey_question_responses.rb",  "db/migrate/create_survey_question_responses.rb"
        try_migration_template "migrations/create_survey_question_groups.rb",     "db/migrate/create_survey_question_groups.rb"

      end

    end
  end
end
