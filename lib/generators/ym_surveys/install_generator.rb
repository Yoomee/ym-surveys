module YmSurveys
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include YmCore::Generators::Migration

      source_root File.expand_path("../templates", __FILE__)
      desc "Installs YmSurveys."

      def manifest
        # models

        # views

        # controllers

        # migrations
        try_migration_template "migrations/create_ym_surveys.rb", "db/migrate/create_ym_surveys"
        try_migration_template "migrations/create_ym_survey_questions.rb", "db/migrate/create_ym_survey_questions"
        try_migration_template "migrations/create_ym_survey_submissions.rb", "db/migrate/create_ym_survey_submissions"
        try_migration_template "migrations/create_ym_survey_question_responses.rb", "db/migrate/create_ym_survey_question_responses"
        try_migration_template "migrations/create_ym_survey_question_groups.rb", "db/migrate/create_ym_survey_question_groups"

      end

    end
  end
end
