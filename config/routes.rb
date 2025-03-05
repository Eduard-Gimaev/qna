# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    member do
      post 'like'
      post 'dislike'
    end
  end

  concern :commentable do
    resources :comments, only: %i[create destroy], shallow: true
  end

  resources :questions, concerns: [:votable, :commentable], shallow: true do
    resources :answers, concerns: [:votable, :commentable], shallow: true do
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
