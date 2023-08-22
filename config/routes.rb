Rails.application.routes.draw do
  resources :tasks do
    member do
      patch 'mark_status'
    end
  end

  resources :tags, only: [:index, :show]
end
