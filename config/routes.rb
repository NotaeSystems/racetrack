Myapp::Application.routes.draw do
  resources :comments

  resources :rankings

  resources :bets

  resources :credits

  resources :horses



  resources :cards

  resources :meets do
      collection do
        #get ''
      end
      member do
        get 'refresh_credits'
        #get 'credits'
      end 

  end

  resources :tracks

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users

  ##### tracks
    resources :tracks do
      collection do
        #get 'members'
      end
      member do
        #get 'users'
        #get 'credits'
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
        #get 'members'
      end
      member do
        get 'close'
        get 'payout'
        
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
