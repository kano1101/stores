Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check
  get "/", to: "home#index"
  get "/csv/summary", to: "home#summary"
  get "/csv/page_rank", to: "home#page_rank"
  get "/csv/link_rank", to: "home#link_rank"

  # Defines the root path route ("/")
  # root "posts#index"
end
