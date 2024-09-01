# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  resources :questions, shallow: true do
    resources :answers, shallow: true do
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
