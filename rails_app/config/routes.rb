Rails.application.routes.draw do
  get 'home/index'

  root "home#index"
  # resources :users, path: "traders", controller: "traders"
  resources :users
  get "render", to: "users#custom_render_traders"
  resources :cards
  get "jobs/:status", to: "jobs#index", fetch: "People"
  get 'jobs/create'
  get 'jobs/index'
  get 'jobs/new'
  get 'jobs/edit'
  get 'job/create'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
