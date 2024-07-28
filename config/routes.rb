Rails.application.routes.draw do
  devise_for :users

  resources :questions, shallow: true do
    resources :answers, shallow: true, only: %i[create destroy]
  end

  root to: 'questions#index'

end
