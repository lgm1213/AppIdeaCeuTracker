Rails.application.routes.draw do
  root "home#index"

  # Authentication & Registration Routes
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  resources :password_resets, only: [ :new, :create, :edit, :update ], param: :token


  # Registration Routes
  get "/signup", to: "registrations#new", as: "signup"
  post "/signup", to: "registrations#create"

  # Dashboard(Protected Area) Routes
  get "dashboard/index", to: "dashboard#index", as: "dashboard"

  # User Profile Management Routes
  resource :profile, only: [ :edit, :show, :update ]

  # Professional License & CEU Management Routes
  resources :professional_licenses, only: [ :new, :create, :edit, :update, :destroy ]
  resources :ceus, only: [ :new, :create, :edit, :update, :destroy ]

  # Reporting Routes
  get "reports/export", to: "reports#export", as: "export_report"

  # Search / Events Routes
  resources :events, only: [ :index, :show ]

  # Saved Events Routes
  resources :saved_events, only: [ :create, :destroy, :index ]

  # Admin Namespace Routes
  # Only accessible by admin users
  namespace :admin do
    resources :ceu_events, except: [ :show ]
  end



  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
