Rails.application.routes.draw do
  resources :questions do
    resources :answers, shallow: true, only: %i[index]
  end

  resources :answers

end
