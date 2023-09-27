Rails.application.routes.draw do
  devise_scope :user do
    unauthenticated do
      root to: 'users/sessions#new', as: :unauthenticated_root
    end

    root to: 'users/registrations#show'
    get 'users', to: 'users/registrations#show'
    get 'users/sign_out', to: 'users/sessions#destroy'
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  resources :books

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
