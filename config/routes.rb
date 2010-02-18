Pulse::Application.routes.draw do
  match '/logout' => 'sessions#destroy', :as => :logout
  resource :session
  resource :login

  resources :users
  match '/register' => 'users#create', :as => :register
  match '/signup'   => 'users#new', :as => :signup

  resource  :pulse
  resources :projects
  resources :messages

  match ''  => 'default#show', :as => :home_page
  root  :to => 'default#show'
end
