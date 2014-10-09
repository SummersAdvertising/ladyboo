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

  end
  
  
  # get '(*url)'   => 'errors#index'
  
end