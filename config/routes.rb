Pulse::Application.routes.draw do
  root  :to => 'default#show'
  match ''  => 'default#show', :as => :home_page

  match '/pulse' => 'pulse#show', :as => :pulse
  resources :projects
  resources :messages

  match '/logout' => 'sessions#destroy', :as => :logout
  resource :session
  resource :login, :controller => 'sessions'

  resources :users
  match '/register' => 'users#create', :as => :register
  match '/signup'   => 'users#new', :as => :signup
end
