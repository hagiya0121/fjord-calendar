Rails.application.routes.draw do
  resources :calendars do
    resources :entries, shallow: true
  end
end
