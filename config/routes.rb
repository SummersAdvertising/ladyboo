Rails.application.routes.draw do
  
  devise_for :admins#, :path => 'ladybooadmin', :path_names => {:sign_in => 'login', :sign_out => 'logout'}

  root "statics#index"

  resources :pages, :controller => :statics do 
    collection do
      get ':page', :action => :show, :as => :page
    end
  end

  namespace :admin do
    authenticated :admin do
      root "announcements#index"
      #root "orders#index"#, :as => :authenticated_root
    end
    resources :admins
    
    mount Ckeditor::Engine => '/ckeditor'
    
    resources :categories do 
      resources :products do

        get   '/photos'       => 'products#photo', as: 'photo'
        patch  '/upload_photo'       => 'products#upload_photo'

        resources :measurements
        # resources :accessories
        # resources :features
        # resources :colors
      end
    end

    resources :banners
    resources :pickups
    resources :topics
    resources :topic_productships
    resources :lookbooks
    resources :lookbook_topicships
    resources :topic_collections
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

    resources :deliveries
    
    delete 'peditor/deletePhoto/:id'        => 'peditor#destroyPhoto'

  end #admin scope end
  
  
  # get '(*url)'   => 'errors#index'
  
end