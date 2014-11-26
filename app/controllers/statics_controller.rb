#encoding: utf-8
class StaticsController < ApplicationController
  layout false , only: [:index]

  def index
    expires_in 5.minutes

    @current_root = Category.return_root_node
    @categories = Category.get_level_hierarchy()

    @banners = Banner.includes(:galleries).where(status: 'enable').limit(5)
    @lookbook = Lookbook.where(status: 'enable').first
    @tiles = @lookbook.tiles.includes(:galleries) if @lookbook

    @topic_collections = TopicCollection.includes(:galleries).where(status: 'enable').order(created_at: :desc).limit(4)
    
    @pickups = Pickup.includes(:product, :galleries, :categories).where(status: 'enable').limit(12)
    @tracking_list = TrackingList.new
    if current_user
      @tracking_lists = current_user.tracking_lists.includes(:product, :galleries, :categories).latest
    end

  end

  def about
    expires_in 5.minutes

    @announcements = Announcement.for_index.limit(3)
    @communities = Community.for_index.limit(3)
  end

  def show
    expires_in 5.minutes
    
    if params[ :page ].nil?
      redirect_to :index
    end
    
    respond_to do | format |
      format.html { render :template => 'statics/' + params[ :page ]  rescue redirect_to '/errors' }
    end
    
  end

end
