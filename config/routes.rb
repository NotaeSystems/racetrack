Myapp::Application.routes.draw do
  
  #get "sessions/new"
  resources :users
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
  #match '/auth/facebook/callback' => 'authentications#create'
  match '/auth/:provider/callback' => 'authentications#create'
  match '/home/' => 'home#index', as: :home

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
  match "privacy" => "home#privacy", :as => :privacy
  match "terms" => "home#terms", :as => :terms
  match "about" => "home#about", :as => :about
  match "contact" => "home#contact", :as => :contact
  match "faq" => "home#faq", :as => :faq
  match "myaccount" => "users#myaccount", :as => :myaccount
  match "myleagues" => "users#myleagues", :as => :myleagues
  match "mytracks" => "users#mytracks", :as => :mytracks
  match "mycredits" => "users#mycredits", :as => :mycredits
  match "mybets" => "users#mybets", :as => :mybets
  match "myachievements" => "users#myachievements", :as => :myachievements
  match "login_as" => "users#login_as", :as => :login_as
  match "backdoor" => "authentications#backdoor", :as => :backdoor
  match "exacta" => "bets#exacta", :as => :exacta
  match "trifecta" => "bets#trifecta", :as => :trifecta
  post "create_exacta" => "bets#create_exacta", :as => :create_exacta

get 'add_role', to: 'users#add_role', as: 'add_role'
get 'remove_role', to: 'users#remove_role', as: 'remove_role'
get 'signup', to: 'users#new', as: 'signup'
get 'login', to: 'sessions#new', as: 'login'
get 'logout', to: 'sessions#destroy', as: 'logout'


 ### Pusher ###############
  match "push_card_message" => "cards#push_message", :as => :push_card_message

  match "card_message" => "cards#message", :as => :card_message
#########################

  resources :leagues  do
      collection do
        #get ''
      end
      member do
        get 'join'
        get 'quit'
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
end
