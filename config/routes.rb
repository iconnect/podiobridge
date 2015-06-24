Rails.application.routes.draw do
 root 'dashboard#index'

 get "/login", to: "sessions#new"
 post "/login", to: "sessions#create"
 get "/logout", to: "sessions#logout"

end
