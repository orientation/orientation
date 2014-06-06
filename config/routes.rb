Rails.application.routes.draw do

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  resources :tags

  resources :authors, only: [:index, :show, :new, :create, :update] do
    put :toggle_status, to: "authors#toggle_status", as: "toggle_status"
  end

  resources :articles do
    get :archived, on: :collection
  	put :make_fresh, on: :member
    put :toggle_archived, on: :member
    post :toggle_subscription, on: :member
    put :toggle_rotten, on: :member
  end

  resources :articles, path: "", only: :show

  root "articles#index"
end
