Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # defaults to dashboard
  root :to => redirect('/dashboard')
  
  # view routes

  resources :sensors
  resources :makers, except: [:new] 
  resources :map
  resources :charts

  
  get '/dashboard' => 'dashboard#index'
  get '/triggers' => 'triggers#index'

  get '/login', to: "logins#new"
  post '/login', to: "logins#create"
  get '/logout', to: "logins#destroy"

  get '/register', to: 'makers#new'
  
  # api routes
  get '/api/i18n/:locale' => 'api#i18n'

end
