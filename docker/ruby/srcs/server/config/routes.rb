Rails.application.routes.draw do
  resources :chatrooms
  root "home#index"
  get "home", to: "home#index"

  scope "api" do
    resources :games
    resources :pongs
    resources :chatrooms do
      member do
        post 'login'
        put 'set_admin'
        put 'unset_admin'
        put 'ban_user'
        put 'unban_user'
        put 'mute_user'
        put 'unmute_user'
        put 'leave'
        put 'join'
        put 'unjoin'
      end
    end
    post '/chats', to: "chats#create"

    resources :friends
    put '/users/unset_ft'
    put '/users/edit_profile'
    put '/users/block_user'
    put '/users/unblock_user'
    put '/users/enable_2fa'
    put '/users/disable_2fa'

    put 'admin/set_admin'
    put 'admin/unset_admin'
    put 'admin/ban_user'
    put 'admin/unban_user'

    resources :private_rooms
    post '/private_messages', to: "private_messages#create"

    resources :guilds
    resources :guild_invitations
    post '/guilds/leave_guild', to: "guilds#leave_guild"
    post '/guilds/join_guild', to: "guilds#join_guild"
    post '/guilds/promote', to: "guilds#promote"
    post '/guilds/demote', to: "guilds#demote"
    post '/guilds/kick', to: "guilds#kick"

    resources :guild_wars
    put '/guild_wars/accept_request/:id', to: "guild_wars#accept_request"
    put '/guild_wars/forfeit/:id', to: "guild_wars#forfeit"

    get '/tournaments', to: "tournaments#index"
    post '/tournaments', to: "tournaments#create"
    delete '/tournaments/:id', to: "tournaments#destroy"
    put '/tournaments/:id/register', to: "tournaments#register"
    put '/tournaments/:id/unregister', to: "tournaments#unregister"

    post '/pongs/spectate', to: "pongs#spectate"
    post '/pongs/duel_demand', to: "pongs#duel_demand"
    post '/pongs/accept_duel', to: "pongs#accept_duel"
    post '/pongs/decline_duel', to: "pongs#decline_duel"
  end

  get 'my_friends', to: "friends#index"
  devise_for :users, controllers: { registrations: 'registrations/registrations', omniauth_callbacks: "registrations/omniauth_callbacks" }
  get 'users', to: "users#index"
  get 'users/:id', to: "users#show", as: 'user'

  match "*path", to: "application#error_404", :via => [:get, :post, :delete, :put, :patch]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
