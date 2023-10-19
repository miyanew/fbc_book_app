Rails.application.routes.draw do

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }
  
  get 'users', to: 'users#index'
  get 'users/:id', to: 'users#show', as: 'user_profile'

  resources :books

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
