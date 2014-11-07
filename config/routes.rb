Rails.application.routes.draw do
  
  devise_for :users, controllers: { registrations: 'registrations' }
  devise_for :admins#, :path => 'ladybooadmin', :path_names => {:sign_in => 'login', :sign_out => 'logout'}

  root "statics#index"

  resources :pages, :controller => :statics do 
    collection do
      get "about" => "statics#about", :as => "about"
      get ':page', :action => :show, :as => :page
    end
  end

  resources :categories, :only => [ :index, :show] do 
    resources :products, :only => [ :show] do
      # member do 
      #   get :fetch_stock_amount
      #   get 'quickview' , :action => 'quickview'
      # end
    end
  end

  resources :products, only: [:search] do
    collection do
      match 'search' => 'products#search', via: [:post], as: :search  
    end
  end

  resources :products, only: [:show] do 
    member do 
      get 'quickview' , :action => 'quickview'
    end
    collection do 
      get :fetch_stock_amount
    end
  end

  resources :contacts, only: [:index, :create]

  resources :announcements, only: [:index]
  resources :communities, only: [:index]

  resources :topic_collections, :only => [ :show ] do
    resources :topics, :only => [:show] do 
      resources :categories, :only => [ :index, :show] do
        resources :products, only: [:show] do 
          member do 
            get 'quickview' , :action => 'quickview'
          end
          collection do 
            get :fetch_stock_amount
          end
        end
      end
    end
  end


  resources :lookbooks, :only => [:show] do 
    resources :topics, :only => [:show] do 
      resources :categories, :only => [ :index, :show] do
        resources :products, only: [:show] do 
          member do 
            get 'quickview' , :action => 'quickview'
          end
          collection do 
            get :fetch_stock_amount
          end
        end
      end
    end 
  end

  # cart
  resources :cart, :only => [:index, :create] do
    collection do
      get "check" => "cart#check" , :as => "check"
      get "final_check/" => "cart#final_check", :as => "final_check"
      get "finish"
      get "confirm" => "cart#confirm", :as => "confirm"
      #
      post "set_ship_to/:shipping_to" => "cart#set_ship_to" , :as => "set_ship_to"
      get "fail"
      #金流串接
      get "post_order/:id" => "cart#post_order", :as => "post_order"
      match "receive_result" => "cart#receive_result", via: [:get, :post]

      #paypal
      get "express_checkout" => "cart#express_checkout"
      
      match "add" => "cart#add" , :via => :post
    end

    member do
      match "plus" => "cart#plus" , :via => :post , :as => "plus"
      match "minus" => "cart#minus" , :via => :post , :as => "minus"
      # match "delete_by_attribute/:index" => "cart#delete_by_attribute", :via => :post , :as => "delete_by_attribute"
      match "delete" => "cart#delete" , :via => :delete

    end
  end # cart end

  namespace :useradmin do
    
    resources :users, :only => [:index ,:update]
    resources :addressbooks , :only => [:index, :create, :destroy ,:update]
    resources :tracking_lists , :only => [:index, :create, :destroy ,:update]
    
    resources :orders, :only => [:index, :show] do
      member do
        resources :orderasks, :only => [:new, :create]
        patch :atm_transfered #the only action that user allow to triggered
      end
    end
  
    root "orders#index"

  end # useradmin scope end

  namespace :admin do
    authenticated :admin do
      root "announcements#index"
      #root "orders#index"#, :as => :authenticated_root
    end
    resources :admins
    
    mount Ckeditor::Engine => '/ckeditor'
    
    resources :categories do 
      resources :products do

        post  'peditor/:id/createPhoto'       => 'peditor#createPhoto'

        get   '/free_paragraph'       => 'products#free_paragraph'
        patch  '/free_paragraph'       => 'products#update_parapraph'

        resources :stocks, :only => [:index, :create, :update, :destroy]

        get   '/photos'       => 'products#photo', as: 'photo'
        patch  '/upload_photo'       => 'products#upload_photo'

        resources :measurements
        # resources :accessories
        # resources :features
        # resources :colors
      end
    end

    resources :products do 
      collection do 
        get '/out_of_stock' => 'products#out_of_stock'
        get '/disabled' => 'products#disabled'
      end
      member do
        patch 'reorder' , :action => 'reorder'
      end 
    end

    resources :banners
    resources :pickups
    
    resources :topics do
      get   '/photos'       => 'topics#photo', as: 'photo'
      patch  '/upload_photo'       => 'topics#upload_photo'
    end

    resources :topic_productships

    resources :lookbooks do 
      resources :tiles

      get   '/photos'       => 'lookbooks#photo', as: 'photo'
      patch  '/upload_photo'       => 'lookbooks#upload_photo'

    end

    resources :tiles do
      member do
        patch 'reorder' , :action => 'reorder'
      end 
    end

    resources :lookbook_topicships
    resources :topic_collections do 
      get   '/photos'       => 'topic_collections#photo', as: 'photo'
      patch  '/upload_photo'       => 'topic_collections#upload_photo'
    end
    resources :topic_collection_topicships

    resources :announcements do 
      member do
        post  'peditor/:id/createPhoto'       => 'peditor#createPhoto'
        post 'create_announcement_attachment' , :action => 'create_announcement_attachment'

        get '/custom_edit' => 'announcements#custom_edit'
        patch '/custom_edit' => 'announcements#update'

      end
    end

    resources :communities do 
      member do
        post  'peditor/:id/createPhoto'       => 'peditor#createPhoto'
        post 'create_community_attachment' , :action => 'create_community_attachment'

        get '/custom_edit' => 'communities#custom_edit'
        patch '/custom_edit' => 'communities#update'

      end
    end

    resources :galleries do 
      member do
        patch 'multiple_reorder' , :action => 'multiple_reorder'
      end 
    end

    resources :orders, :only => [:index, :show] do
      member do 
        #AASM
        post :checkout_succeeded_ATM # should remove
        post :cancel_before_paid_ATM
        post :atm_transfered
        post :money_placed_ATM
        post :atm_comfirmed
        
        post :checkout_succeeded_Vaccount # should remove
        post :cancel_before_paid_Vaccount
        post :comfirmed_Vaccount
        #post :human_involving_after_order_placed
        
        post :checkout_succeeded_COD # should remove
        post :shipping_COD
        post :post_collect_checked
        post :human_involving_after_order_placed_COD
        post :human_involving_post_collect_COD

        post :checkout_succeeded_general # should remove
        post :shipping_first
        post :human_involving_after_order_placed_general

        
        #SHARED
        post :checkout_failed # should remove
        post :shipping

        patch :shipping
        patch :shipping_first
        patch :shipping_COD
        patch :human_involving_after_order_placed_COD
        patch :human_involving_post_collect_COD
        patch :human_involving_after_order_placed_general
        patch :human_involving_after_money_placed
        patch :human_involving_after_money_checked
        patch :human_involving_after_shipped
        patch :human_involved_edit
        

        post :human_involved_edit
        post :human_involving_after_money_placed
        post :human_involving_after_money_checked
        post :human_involving_after_shipped
        post :close_deal
        post :to_abnormal

        get '/info_hub/:event' => 'orders#info_hub'
        post '/info_hub/:event' => 'orders#update_from_info_hub'

        get 'detail' => 'orders#detail'

      end

      collection do
        #金流：查詢交易狀態
        get "query_order_status/:id" => "orders#query_order_status", :as => "query_order"
        get "receive_order_status" => "orders#receive_order_status"

        get '/todolist' , action: 'index'
        get '/shipped' , action: 'shipped'
        get '/pending' , action: 'pending'
        get '/human_involved' , action: 'human_involved'
        #get '/history' , action: 'history'
        match 'history' => 'orders#history', via: [:get, :post], as: :history
        
      end

    end

    resources :orderasks, :only => [:index, :update] do
      collection do 
        get 'history', action: 'history'
      end
    end
    resources :users , :only => [:index, :show] do 
      collection do 
        get 'export', action: 'export'
        #get 'search', action: 'search'
      end
    end
    resources :deliveries
    
    delete 'peditor/deletePhoto/:id'        => 'peditor#destroyPhoto'

  end #admin scope end
  
  
  #get '(*url)'   => 'errors#index'
  
end