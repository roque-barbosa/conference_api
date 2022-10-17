Rails.application.routes.draw do
  resources :lectures
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get '/tracks', to: 'lectures#show_tracks'
  # post '/tracks', to: 'lectures#import_tracks'

  post '/tracks', to: 'lectures#import'
end
