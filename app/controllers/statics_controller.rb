#encoding: utf-8
class StaticsController < ApplicationController
  layout false , only: [:index]

  def index
    # shared in application_controller
    # @root_node = Category.return_root_node
    # @hierarchy = Category.get_level_hierarchy()
    # @lookbook = Lookbook.where(status: 'enable').first
    # @topics = @lookbook.topics if @lookbook # lookbook topics
    # @levels = @hierarchy.select { |v| v[2] == @root_node.id }

    @banners = Banner.includes(:galleries).where(status: 'enable').limit(5)
    
    @tiles = @lookbook.tiles.includes(:galleries) if @lookbook
    

    @topic_collections = TopicCollection.includes(:galleries).where(status: 'enable').order(created_at: :desc).limit(4)
    
    @pickups = Pickup.includes(:product, :galleries, :categories).where(status: 'enable').limit(12)
    @tracking_list = TrackingList.new
    if current_user
      @tracking_lists = current_user.tracking_lists.includes(:product, :galleries, :categories).latest
    end
    
  end

  def about

    @announcements = Announcement.for_index.limit(3)
    @communities = Community.for_index.limit(3)
    
  end

  def show
    
    if params[ :page ].nil?
      redirect_to :index
    end
    
    respond_to do | format |
      format.html { render :template => 'statics/' + params[ :page ]  rescue redirect_to '/errors' }
    end
      
  end

end
