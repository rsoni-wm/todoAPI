Rails.application.routes.draw do
  resources :tasks ,  :except => [:new, :edit] do
    member do

      put 'restore'
    end
    collection do
      get 'searchby_tag/:tag', action: 'searchby_tag'
    end
  end



end
