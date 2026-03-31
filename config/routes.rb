# config/routes.rb
Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  scope :api, defaults: { format: :json } do
    scope :v1 do
      # --- Auth Routes ---
      devise_for :users, path: '', path_names: {
        sign_in: 'login', sign_out: 'logout', registration: 'register'
      }, controllers: {
        registrations: "api/v1/users/registrations",
        sessions: "api/v1/users/sessions"
      }

      # --- Public/Customer Routes ---
      scope module: 'api/v1' do
        resources :reservations, only: [:index, :create, :destroy]
        resources :cars, only: [:index, :show]
        get 'profile', to: 'users#profile'
        
        # --- Admin/Owner Routes ---
        namespace :admin do
          resources :cars do
            member do
              patch :availability # PATCH /api/v1/admin/cars/:id/availability
            end
            # GET /api/v1/admin/cars/:car_id/status_histories
            resources :status_histories, only: [:index], controller: 'car_status_histories'
          end
        end
      end

    end
  end
end