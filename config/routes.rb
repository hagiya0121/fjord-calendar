Rails.application.routes.draw do
  get 'users/show'
  root to: 'calendars#index'

  resources :calendars, param: :year do
    resources :entries, shallow: true
  end

  resources :users, only: [:show]

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
  }

  devise_scope :user do
    delete 'users/sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  get 'up' => 'rails/health#show', as: :rails_health_check
end
