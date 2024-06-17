Rails.application.routes.draw do
  root to: 'questions#index'
  devise_for :users

  resources :questions do
    resources :answers, shallow: true, only: %i[create update destroy] do
      patch 'set_best', on: :member, to: 'answers#best'
    end
  end

  resources :files, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index
end
