GrClone::Application.routes.draw do
  devise_for :users

  root :to => 'feed#index'
  get 'feed/index'

  resources :feed do
    collection do
      get 'refresh_all'
    end
  end

  resources :feed_item do
    member do
      get 'mark_read'
    end
  end
end
