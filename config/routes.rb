Rails.application.routes.draw do
  resources :survey_questions
  resources :surveys do
    resources :survey_submissions, :only => [:index, :show]
    post '/steps/:step_id', to: 'survey_submissions#create', :as => :step
  end
  resources :survey_submissions, :only => [:create]
end