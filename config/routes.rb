Rails.application.routes.draw do

  get 'auth/:provider/callback', to: 'sessions#create', as: :oauth_callback
  get 'auth/failure', to: redirect('/')
  get 'login', to: 'sessions#new', as: :login
  get 'logout', to: 'sessions#destroy', as: :logout

  resources :tags

  resources :authors, only: [:index, :show, :new, :create, :update] do
    put :toggle_status, to: "authors#toggle_status", as: "toggle_status"
  end

  resources :articles do
    get :archived, on: :collection
    put :toggle_subscription, on: :member
    put :toggle_endorsement, on: :member
    put :report_rot, on: :member
    put :mark_fresh, on: :member
    put :toggle_archived, on: :member
    get :subscriptions, on: :member
  end

  resources :guides, only: [:show, :index]

  resources :articles, path: "", only: :show

  root "guides#index"
end
