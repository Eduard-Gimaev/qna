# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    member do
      post 'like'
      post 'dislike'
    end
  end

  resources :questions, concerns: [:votable], shallow: true do
    resources :answers, concerns: [:votable], shallow: true do
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

  root to: 'questions#index'
end
