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
      end 
      resources :cars, only: [:index, :show, :create, :update]
      get 'all_cars/', to: 'cars#all_cars', as: 'all_cars'
      patch 'cars/:id/availability', to: 'cars#availability', as: 'car_availability'
    end
  end
  
end