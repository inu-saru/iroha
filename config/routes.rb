Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :ping, only: :index
      devise_for :users, path: '',
                         path_names: {
                           sign_in: 'login',
                           sign_out: 'logout',
                           registration: 'signup'
                         },
                         controllers: {
                           sessions: 'api/v1/users/sessions',
                           registrations: 'api/v1/users/registrations'
                         }
    end
  end
end
