Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resource :users, only: :create
  get '/flowers', to: 'flowers#index'

  resources :flowers do
    resources :sightings, only: [:create, :index, :destroy]
  end

  # I could put this inside sightings implemented in flowers resources
  resources :sightings do
    resources :likes, only: [:create, :destroy]
  end

  post '/login', to: 'users#login'
  get '/auto_login', to: 'users#auto_login'
end
