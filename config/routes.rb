Rails.application.routes.draw do
  root to: 'questions#index'
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  concern :votable do
    member do
      post :vote_up
      post :vote_down
    end
  end

  concern :commentable do
    member { post :add_comment }
  end

  resources :questions, concerns: %i[votable commentable] do
    resources :answers, shallow: true, only: %i[create update destroy], concerns: %i[votable commentable] do
      patch 'set_best', on: :member, to: 'answers#best'
    end
  end

  resources :files, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index

  mount ActionCable.server => '/cable'
end
