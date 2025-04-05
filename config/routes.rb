Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations" }
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

    resources :pets, only: [:show, :new, :create, :edit, :update, :destroy] do

      resources :favorites, only: [:create, :destroy]
      post 'create_chatroom', to: 'chatrooms#create_chatroom', as: 'create_chatroom'

      collection do
        post :update_breeds
      end

    end

    resources :chatrooms, only: [:index, :create] do
      resources :messages, only: [:create, :update] do
        collection do
          get :chatroom_messages
        end
      end
      # resources :reviews, only: [:new, :create, :update]
      resources :reviews, only: [:create, :update]
    end
    # resources :reviews, only: [:index]
  end

  get '/my_reviews', to: 'reviews#index', as: 'my_reviews'
  resources :reviews, only: :destroy

  # Defines the root path route ("/")
  # root "posts#index"
  get "test" => "pages#test", as: :test
  resources :prompts, only: [:create]


  get "search" => "pages#search", as: :get_search
  post "/search", to: "pages#search", as: :search


  get "/other_matches", to: "pages#other_matches", as: :other_matches # Route for other_matches page


  # delete '/pets/:id', to: 'pets#destroy', as: 'remove_pet'
  delete '/users/:user_id/pets/:id', to: 'pets#destroy', as: 'remove_pet'

  # delete '/users/:user_id/pets/:pet_id/favorites', to: 'favorites#destroy', as: 'user_pet_favorites'

end
