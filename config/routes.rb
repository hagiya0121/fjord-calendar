Rails.application.routes.draw do
  root to: 'calendars#index'

  resources :calendars do
    resources :entries, shallow: true
  end
end
