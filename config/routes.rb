Rails.application.routes.draw do
  resources :questions do
    resources :answers, shallow: true, except: %i[show index]
  end
end
