Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  scope :api, defaults: { format: :json } do
    scope :v1 do
      devise_for :users, # => this is the devise_for :users that is used for the api
                 controllers: {
                   registrations: "api/v1/users/registrations",
                   sessions: "api/v1/users/sessions",
                 },
                 path: "",
                 path_names: {
                   sign_in: "login",
                   sign_out: "logout",
                   registration: "register",
                 }
    end
  end

  # API routes
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index] do
        resources :bookings, only: [:index, :create, :destroy],:path => 'reservations'
        resources :cars, only: [:create, :update]
        patch 'cars/:id/availability', to: 'cars#availability', as: 'car_availability'
      end
      get 'owners/:user_id/cars', to: 'cars#owner_cars', as: 'owner_cars'
      resources :cars, only: [:index, :show]
    end
  end

end