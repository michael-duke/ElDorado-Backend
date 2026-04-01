# config/routes.rb
Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  scope :api,  defaults: { format: :json } do
    scope :v1 do
      scope module: 'api/v1' do
        # --- Auth Routes ---
        devise_for :users, path: '', path_names: {
          sign_in: 'auth/login', sign_out: 'auth/logout', registration: 'auth/register'
          }, controllers: {
            registrations: "api/v1/auth/registrations",
            sessions: "api/v1/auth/sessions"
          }
          
        # --- Public/Customer Routes ---
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

 