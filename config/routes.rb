Rails.application.routes.draw do
  devise_for :users
  
  resources :questions do
    resources :answers, shallow: true, only: %i[new create]
  end

  root to: 'question#index'

end
