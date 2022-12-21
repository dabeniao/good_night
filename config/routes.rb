Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :following_users, only: [:update, :destroy], defaults: {format: :json}
  resources :sleep_sessions, only: [:create, :index], defaults: {format: :json} do
    get :following, on: :collection
  end
end
