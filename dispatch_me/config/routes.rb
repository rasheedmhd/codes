Rails.application.routes.draw do
  get 'persons/index'
  get 'persons/new'
  get 'persons/create'
  get 'persons/update'
  get 'persons/edit'
  get "demo" => "demo#index"
  get "render" => "demo#renderrr"
  get "notemplate" => "demo#no_t"
  get "nothing" => "demo#nothing"
  get "layout" => "demo#clayout"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
