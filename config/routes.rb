Rails.application.routes.draw do

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  devise_scope :user do
    get 'users', to: 'users/registrations#index'
    get 'users/:id', to: 'users/registrations#show', as: 'user_profile'
  end

  resources :books

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
