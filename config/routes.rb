Rails.application.routes.draw do
  

  devise_for :admins
  resources :events do
    collection do
      get '/mine' => 'events#mine'
      get '/search' => 'events#search'
      get '/i_am_attending' => 'events#rsvps'
      get '/filter' => 'events#filter'
    end
    resources :sessions do
      collection do
        get '/create_rsvp' => 'sessions#create_rsvp'
        get '/destroy_rsvp' => 'sessions#destroy_rsvp'
      end
    end
  end

  root 'events#index'

  get '/signin', to: redirect('/auth/twitter'), :as => :signin
  get '/auth/:provider/callback' => 'user_session#create'
  get '/signout' => 'user_session#destroy'
  get '/auth/failure' => 'user_session#failure'
end
