namespace :api do
  namespace :v1 do
    resources :profiles, only: %i[index show create update destroy] do
      get :me, on: :collection
    end
    resources :questions, only: %i[index show create update destroy] do
      resources :comments, only: %i[index create destroy], shallow: true
      resources :answers, only: %i[index create show update destroy], shallow: true
    end
  end
end
