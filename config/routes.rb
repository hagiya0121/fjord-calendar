Rails.application.routes.draw do
  root to: 'calendars#index'

  resources :calendars do
    resources :entries, shallow: true
  end

  get '/auth/github/callback', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy', as: :logout
end
