Rails.application.routes.draw do
  devise_for :users, path: 'api/v1',
                     path_names: {
                       sign_in: 'login',
                       sign_out: 'logout',
                       registration: 'registration'
                     },
                     controllers: {
                       sessions: 'api/v1/sessions',
                       registrations: 'api/v1/registrations'
                     }
  namespace :api do
    namespace :v1 do
      # 'api/v1/batch' はmiddleware管理 -> lib/middlewares/batch_api.rb
      resources :ping, only: :index
      namespace :users do
        get 'me', to: 'me#show'
      end
      resources :spaces, controller: 'spaces/index' do
        resources :sections, controller: 'sections/index'
        resources :vocabularies, controller: 'vocabularies/index' do
          member do
            get :following, :followers, controller: 'vocabularies/follow'
          end
          collection do
            post 'bulk', controller: 'vocabularies/bulk', action: 'create'
          end
        end
        resources :relationships, controller: 'relationships/index'
      end
    end
  end
end
