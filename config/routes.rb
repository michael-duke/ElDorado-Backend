Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  scope :api, defaults: { format: :json } do
    scope :v1 do
      # Auth Routes
      devise_for :users,
        path: '',
        path_names: {
          sign_in: 'login',
          sign_out: 'logout',
          registration: 'register'
        },
        controllers: {
          registrations: "api/v1/users/registrations",
          sessions: "api/v1/users/sessions"
        }

      scope module: 'api/v1' do
        # Business Routes
        resources :reservations, only: [:index, :create, :destroy]
        
        resources :cars, only: [:index, :show, :create, :update] do
          member do
            patch :availability # PATCH /api/v1/cars/:id/availability
          end
        end
        
        get 'profile', to: 'users#profile'
        get 'all_cars', to: 'cars#all_cars'
      end
    end
  end
end