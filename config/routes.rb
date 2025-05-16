Rails.application.routes.draw do
  # Root path must be first to ensure it has priority
  root "posts#index"
  
  # API routes
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :show]
    end
  end

  # API Documentation routes
  get '/api-docs', to: redirect('/api-docs/index.html')
  get '/api-docs/index.html', to: 'api_docs#index'

  # Session routes for authentication
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  # RESTful routes for our resources
  resources :organisations do
    post 'leave', on: :member, as: :leave
    post 'join', on: :member, as: :join
  end
  resources :users do
    patch 'depart', on: :member
    patch 'reactivate', on: :member
  end
  resources :posts do
    get 'departed', on: :collection, as: :departed_collection
  end
  
  # Departed posts route
  get '/departed-posts', to: 'posts#departed_posts', as: :departed_posts

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
