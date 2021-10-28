# frozen_string_literal: true

Rails.application.routes.draw do
  resources :follows
  root 'articles#index'

  get 'signup', to: 'users#new'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  resources :users, except: %i[new show]
  get '/:username', to: 'users#show', as: 'show_user'
  post '/users/:id/follow', to: 'users#follow', as: 'follow_user'
  post '/users/:id/unfollow', to: 'users#unfollow', as: 'unfollow_user'

  resources :articles do
    resources :comments
  end
end
