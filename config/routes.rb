Rails.application.routes.draw do
  get "profiles/edit"
  get "profiles/update"
  root "home#index"

  #Dashboard(Protected Area) Routes
  get "dashboard/index", to: "dashboard#index", as: "dashboard"

  #Professional License & CEU Management Routes
  resources :professional_licenses, only: [:new, :create, :edit, :update, :destroy]
  resources :ceus, only: [:new, :create, :edit, :update, :destroy]

  #User Profile Management Routes
  resource :profile, only: [:edit, :update]

  #Authentication & Registration Routes
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  get "/signup", to: "registrations#new", as: "signup" 
  post "/signup", to: "registrations#create"



  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check







end
