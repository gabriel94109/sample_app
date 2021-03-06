SampleApp::Application.routes.draw do
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :sessions, :only => [:new, :create, :destroy]
  resources :microposts, :only => [:create, :destroy, :show]
  resources :relationships, :only => [:create, :destroy]

  match '/signup', :to => 'users#new'
  match '/signin', :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'
  match '/contact', :to => 'pages#contact'
  match '/links', :to => 'pages#links'
  match '/help', :to => 'pages#help'

  match '/:username', :to => 'users#show'

  root :to => 'pages#home'
end
