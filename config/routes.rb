# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  get 'search/index'
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  draw :main
  draw :api
end
