Myflix::Application.routes.draw do
  root to: 'pages#front'

  get 'ui(/:action)', controller: 'ui'

  resources :videos do
    collection do
      get 'search', to: 'videos#search'
    end

    resources :reviews, only: [:create,:edit,:update,:destroy]
  end

  namespace :admin do
    resources :videos
    resources :categories
  end

  resources :categories
  resources :users do
    resources :queue_items, only:[:index,:create,:destroy]
    post 'update_queue', to:'queue_items#update_queue'
    
    resources :friendships, only:[:index, :destroy,:create]
  end

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'
 
end
