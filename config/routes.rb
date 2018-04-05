Myflix::Application.routes.draw do
	root to: 'pages#front'
	get '/home', to: 'videos#index'

	get '/login', to: 'sessions#new' 
	resources :sessions, only: [:create]
	get '/logout', to: 'sessions#destroy'
  get '/register', to: 'users#new'

  get '/people', to: 'relationships#index'
  resources :relationships, only: [:create, :destroy]

  get 'ui(/:action)', controller: 'ui'

  resources :users, only: [:show, :create]

  resources :videos do
  	collection do
  		get :search, to: 'videos#search'
  	end

  	member do
  		# post 'wish', to: 'videos#wish'
  	end
    
    resources :reviews, only: [:create]
  end

  resources :categories, only: [:show]

  get 'my_queue', to: 'queue_items#index'
  resources :queue_items, only: [:create, :destroy]
  post 'update_queue', to: 'queue_items#update_queue'
end