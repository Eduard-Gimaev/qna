use_doorkeeper
root to: 'questions#index'
get 'search', to: 'search#index'

devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

concern :votable do
  member do
    post 'like'
    post 'dislike'
  end
end

concern :commentable do
  resources :comments, only: %i[create destroy], shallow: true
end

resources :questions, concerns: %i[votable commentable], shallow: true do
  resources :subscriptions, only: %i[create destroy], shallow: true
  resources :answers, concerns: %i[votable commentable], shallow: true do
    member do
      patch :mark_as_best
    end
  end
end

resources :users, shallow: true do
  resources :rewards, only: %i[index]
end

resources :attachments, only: %i[destroy]
resources :links, only: %i[destroy]
resources :rewards, only: %i[index destroy]
