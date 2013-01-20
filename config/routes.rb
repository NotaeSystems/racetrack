Myapp::Application.routes.draw do
  
  resources :contracts do
      collection do
        get 'buy'
      end
      member do
        get 'scratch'
        #get 'credits'
      end 
  end

  resources :offers do
      collection do
       # get ''
      end
      member do
         get 'cancel'
       # get 'scratch'
        #get 'credits'
      end 

  end

  resources :transactions

  resources :plans

  resources :subscriptions

  match '/home/' => 'home#index', as: :home

  resources :gates do
      collection do
       # get ''
      end
      member do
        get 'contracts'
        get 'scratch'
        #get 'credits'
      end 

  end


  resources :pages , except: :show
  

  resources :sites

  #get "sessions/new"
  resources :users do
      collection do
        get 'rebuy_credits'
      end
      member do
        get 'offers'
        get 'contracts'
        get 'credits'
        get 'bets'
        get 'rankings'
        get 'transactions'
        get 'leagues'
        get 'tracks'
        get 'clear_user'
      end 

  end
  resources :sessions
  resources :achievementusers
  resources :authentications


  resources :achievements do
      collection do
        #get ''
      end
      member do
        get 'facebook'
        get 'register_facebook'
        #get 'credits'
      end 

  end

  #devise_for :users

  resources :meetleagues do
      collection do
        get 'add'
      end
      member do
        get 'join'
        #get 'credits'
      end 

  end
  ############### Omniauth
  #match '/auth/facebook/callback' => 'authentications#create'
  match '/auth/:provider/callback' => 'authentications#create'

  match '/auth/facebook/setup' => 'authentications#setup_facebook'

  ##################################
  ### tags
  get 'track_tags/:tag', to: 'tracks#index', as: :track_tag
  get 'leagues_tags/:tag', to: 'leagues#index', as: :league_tag
  match "tracks_tag_cloud" => "tracks#tag_cloud", :as => :tracks_tag_cloud
  match "leagues_tag_cloud" => "leagues#tag_cloud", :as => :leagues_tag_cloud
  ####

  resources :trackleagues

  resources :leagueusers



  resources :trackusers

  resources :comments

  resources :rankings

  resources :bets

  resources :credits

  resources :horses do
      collection do
        post 'sort'
      end
      member do
        get 'scratch'
        #get 'credits'
      end 

  end
  
### root administration #####################
  match "admin/dashboard" => "admin#dashboard", :as => :dashboard_admin
  match "admin/tracks" => "admin#tracks", :as => :tracks_admin
  match "admin/transactions" => "admin#transactions", :as => :transactions_admin
  match "admin/destroy_tracks" => "admin#destroy_tracks", :as => :destroy_tracks_admin
##############################################

#### site management ##########################
  match "manage/dashboard" => "manage#dashboard", :as => :dashboard_manage
  match "manage/tracks" => "manage#tracks", :as => :tracks_manage
  match "manage/subscriptions" => "manage#subscriptions", :as => :subscriptions_manage
##############################################

#### stripe #################################
  match "stripeconnect" => "stripe#stripeconnect", :as => :stripeconnect
  match "stripehook" => "stripe#stripehook", :as => :stripehook
##############################################
  match 'my_open_contracts' => "users#my_open_contracts", :as => :my_open_contracts
  match "message" => "home#message", :as => :message
  match "privacy1" => "home#privacy", :as => :privacy
  match "terms1" => "home#terms", :as => :terms
  match "about1" => "home#about", :as => :about
  match "contact1" => "home#contact", :as => :contact
  match "faq1" => "home#faq", :as => :faq
  match "myaccount" => "users#myaccount", :as => :myaccount
  match "myleagues" => "users#myleagues", :as => :myleagues
  match "mytracks" => "users#mytracks", :as => :mytracks
  match "mycredits" => "users#mycredits", :as => :mycredits
  match "mybets" => "users#mybets", :as => :mybets
  match "myachievements" => "users#myachievements", :as => :myachievements
  match "login_as" => "users#login_as", :as => :login_as
  match "return_as_admin" => "users#return_as_admin", :as => :return_as_admin
  match "backdoor" => "authentications#backdoor", :as => :backdoor
  match "exacta" => "bets#exacta", :as => :exacta
  match "trifecta" => "bets#trifecta", :as => :trifecta
  match "back" => "bets#backbet", :as => :backbet
  post "create_exacta" => "bets#create_exacta", :as => :create_exacta
  post "create_backbet" => "bets#create_backbet", :as => :create_backbet

get 'add_role', to: 'users#add_role', as: 'add_role'
get 'remove_role', to: 'users#remove_role', as: 'remove_role'
get 'signup', to: 'users#new', as: 'signup'
get 'borrow', to: 'users#borrow_credits', as: 'borrow'
get 'login', to: 'sessions#new', as: 'login'
get 'logout', to: 'sessions#destroy', as: 'logout'
get 'leaderboard', to: 'sites#leaderboard', as: 'leaderboard'



 ### Pusher ###############
  match "push_card_message" => "cards#push_message", :as => :push_card_message

  match "card_message" => "cards#message", :as => :card_message
#########################

  resources :leagues  do
      collection do
      #  get ''
      end
      member do
        get 'join'
        get 'quit'
        get 'leaderboard'
        #get 'credits'
      end 

  end


  resources :cards do
      collection do
        #get 'message'
      end
      member do
        post 'sort'
        get 'close'
        get 'open'
        get 'message'
        #get 'credits'
      end 

  end

  resources :meets do
      collection do
        #get ''
      end
      member do
        get 'refresh_credits'
        #get 'credits'
      end 

  end


#  authenticated :user do
#    root :to => 'home#index'
#  end
  root :to => "home#index"


  ##### tracks
    resources :tracks do
      collection do
        get 'tag_cloud'
        #get 'members'
      end
      member do
        get 'join'
        get 'quit'
      end 
      ### track/meets
      resources :meets do
        collection do
          #get 'members'
        end
        member do
          #get 'users'
        end 
      end ## end resources meets
    end ### resources tracks

  ##### races
    resources :races do
      collection do
       get 'send_message'
       post 'sort'
      end
      member do
        get 'close'
        get 'cancel'
        get 'payout'
        post 'sort'
        #get 'credits'
      end 
      ### track/meets
      #resources :meets do
      #  collection do
          #get 'members'
     #   end
      #  member do
          #get 'users'
      #  end 
      #end ## end resources meets
    end ### resources race


 # end
  get ':id', to: 'pages#show', as: :page
  put ':id', to: 'pages#update', as: :page
  delete ':id', to: 'pages#destroy', as: :page
end
