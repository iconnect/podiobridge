Rails.application.routes.draw do
 root 'dashboard#index'

 get "/login", to: "sessions#new"
 post "/login", to: "sessions#create"
 delete "/logout", to: "sessions#delete"

 get "/logs", to: "logs#index"

end
