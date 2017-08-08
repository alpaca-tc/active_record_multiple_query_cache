Rails.application.routes.draw do
  resources :queries, only: [] do
    member do
      get 'first'
      get 'all'
    end
  end
end
