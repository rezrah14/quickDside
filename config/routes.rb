Rails.application.routes.draw do
  root to: 'pages#home'
  get 'about', to: 'pages#about'
  resources :projects do
    resources :project_users, only: [:create] 
  end

  resources :project_invitations do
    member do
      put :change_access_level
    end
  end

  get 'signup', to: 'users#new'
  # post 'users', to: 'user#create'
  resources :users, except: [:new]
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'

  get 'join_project', to: 'project_invitations#join_project'
end
