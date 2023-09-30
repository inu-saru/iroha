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
      resources :ping, only: :index
      namespace :users do
        get 'me', to: 'me#show'
      end
      resources :spaces, controller: 'spaces/index' do
        resources :sections, controller: 'sections/index'
        resources :vocabularies, controller: 'vocabularies/index'
        resources :relationships, controller: 'relationships/index', only: [:show, :create, :update, :destroy]
      end
    end
  end
end
