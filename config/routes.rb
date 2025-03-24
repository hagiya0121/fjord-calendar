Rails.application.routes.draw do
  root to: 'calendars#index'

  resources :calendars do
    resources :entries, shallow: true
  end

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
end
