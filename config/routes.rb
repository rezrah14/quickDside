Rails.application.routes.draw do
  root to: 'pages#home'
  get 'about', to: 'pages#about'
  resources :projects
  get 'signup', to: 'users#new'
  # post 'users', to: 'user#create'
  resources :users, except: [:new]
end
