Rails.application.routes.draw do

  get 'auth/:provider/callback', to: 'sessions#create', as: :oauth_callback
  get 'auth/failure', to: redirect('/')
  get 'login', to: 'sessions#new', as: :login
  get 'logout', to: 'sessions#destroy', as: :logout

  resources :tags

  resources :authors, only: [:index, :show, :new, :create, :update] do
    put :toggle_status, to: "authors#toggle_status", as: "toggle_status"
    put :toggle_email_privacy
  end

  resources :articles do
    collection do
      get :fresh
      get :stale
      get :rotten
      get :archived
      get :popular
    end
    member do
      put :toggle_subscription
      put :toggle_endorsement
      put :report_rot
      put :mark_fresh
      put :toggle_archived
      get :subscriptions
    end
  end

  resources :guides, only: [:show, :index]
  resources :subscriptions, only: :index
  resources :endorsements, only: :index

  # this has to be the last route because we're catching slugs at the root path
  resources :articles, path: "", only: :show

  root "guides#index"

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
end
