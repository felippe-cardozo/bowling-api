Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    resources :games, only: [:create] do
      resource :score, only: [:show]
      post '/frames/:number/pinfalls', to: 'pinfalls#create'
    end
  end
end
