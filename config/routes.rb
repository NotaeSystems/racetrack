Myapp::Application.routes.draw do
  resources :bets

  resources :credits

  resources :horses

  resources :races

  resources :cards

  resources :meets

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


 # end
end
