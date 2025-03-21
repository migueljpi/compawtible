Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  post "/", to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  resources :users, only: [:show] do
    resources :pets, only: [:show, :new, :create, :edit, :update, :destroy]
  end

  # Defines the root path route ("/")
  # root "posts#index"
  get "test" => "pages#test", as: :test
  resources :prompts, only: [:create]
  resources :users, only: [:show]
  resources :pets, only: [:show, :create]
  get "search" => "pages#search", as: :search
  post "/search", to: "pages#search"
  get "/other_matches", to: "pages#other_matches", as: :other_matches # Route for other_matches page

end
