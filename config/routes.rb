Rails.application.routes.draw do
  
  devise_for :admins
  
  namespace :admins do
    resources :users do
      collection do
        get '/disable' => 'users#disable'
        get '/enable' => 'users#enable'
      end
    end
  end  

  resources :events do
    collection do
      get '/mine' => 'events#mine'
      get '/search' => 'events#search'
      get '/i_am_attending' => 'events#rsvps'
      get '/filter' => 'events#filter'
      get '/mine_filter' => 'events#mine_filter'
      get '/attending_filter' => 'events#attending_filter'
      get '/disable' => 'events#disable'
    end
    resources :sessions do
      collection do
        get '/create_rsvp' => 'sessions#create_rsvp'
        get '/destroy_rsvp' => 'sessions#destroy_rsvp'
        get '/disable' => 'sessions#disable'
      end
    end
  end

  root 'events#index'

  get '/signin', to: redirect('/auth/twitter'), :as => :signin
  get '/auth/:provider/callback' => 'user_session#create'
  get '/signout' => 'user_session#destroy'
  get '/auth/failure' => 'user_session#failure'
end
