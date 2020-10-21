Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resource :users, only: [:create]
  post "/login", to: "users#login"
  get "/auto_login", to: "users#auto_login"
  post "/device_key", to: "users#device_key"
  delete "/delete", to: "users#delete"
  post "/logout", to: "users#logout"
  post "/refresh", to: "users#refresh"
  post "/validate", to: "users#validate"
end
