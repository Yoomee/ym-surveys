Rails.application.routes.draw do
  resources :survey_questions
  resources :surveys do
    resources :survey_submissions, :only => [:index, :show]
  end
  resources :survey_submissions, :only => [:create]
end