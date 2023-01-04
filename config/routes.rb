Rails.application.routes.draw do
  resources :bookings
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  scope :api, defaults: { format: :json } do
    scope :v1 do 
      devise_for :users, # => this is the devise_for :users that is used for the api
      controllers: { 
        registrations: 'api/v1/users/registrations', 
        sessions: 'api/v1/users/sessions' 
      },
      path: '', 
      path_names: { 
        sign_in: 'login',
        sign_out: 'logout',
        registration: 'register'
      }
    end
  end

  # API routes
  # namespace :api do
  #   namespace :v1 do
  #     resources :users, only: [:index, :show] do 
  #       resources :bookings, only: [:index, :show]
  #     end
  #     resources :cars, only: [:index, :show]
  #   end
  # end
  
  # Defines the root path route ("/") to the cars#index action
  #root to: 'api/v1/cars#index'
end
