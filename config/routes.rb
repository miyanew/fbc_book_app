Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  devise_for :users
  root to: 'books#index'

  concern :commentable do |options|
    resources :comments, only: [:create, :destroy] , module: options[:module_name]
  end

  resources :books do
    concerns :commentable, module_name: 'books'
  end

  resources :users, only: %i(index show)

  resources :reports do
    concerns :commentable, module_name: 'reports'
  end
end
