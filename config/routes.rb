Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :ping, only: :index
    end
  end
end
