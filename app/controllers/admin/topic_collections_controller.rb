#encoding: utf-8
class Admin::TopicCollectionsController < AdminController

  before_action :set_topic_collection, only: [:show, :edit, :update, :destroy]
  #, :create_topic_collection_attachment, :create_selected_topic_collection_attachment
  
  # GET /admin/topic_collections
  # GET /admin/topic_collections.json
  def index 
    @topic_collections = TopicCollection.all #.for_admin
  end

  #new
  def new
    @topic_collection = TopicCollection.new
  end

  def create
    @topic_collection = TopicCollection.new(admin_topic_collection_params)

    respond_to do |format|
      if @topic_collection.save
        flash[:notice] = "更新成功"
        format.html { redirect_to admin_topic_collections_path() }
        #format.js {render :js => "window.location.href=window.location.href;"}
      else
        format.html { redirect_to :back , notice: @topic_collection.errors.full_messages }
      end
    end  
  end

  # GET /admin/topic_collections/1
  # GET /admin/topic_collections/1.json
  def show
  end

  # GET /admin/topic_collections/1/edit
  def edit
    
    #@gallery_count = @topic_collection.galleries.select{ |v| v['type'] == "TopicCollectionPhotoGallery" }.count

    exclude_ids = @topic_collection.topics.pluck(:id)
    if exclude_ids.length != 0
      @topics = Topic.where('id not in (?)', exclude_ids)
    else
      @topics = Topic.all
    end

    @topic_collection_topicship = TopicCollectionTopicship.new
  end
  
  # def photo
  #   @topic_collection = TopicCollection.find_by_id(params[:topic_collection_id])
  #   @gallery_count = @topic_collection.galleries.select{ |v| v['type'] == "TopicCollectionWideCoverGallery" }.count
  # end

  # def upload_photo
  #   @topic_collection = TopicCollection.find_by_id(params[:topic_collection_id])
  #   #deal with attachment
  #   if params[:filename].present? 
  #     display_name = params[:filename] 
  #   else 
  #     display_name = "#{@topic_collection.name}-topic_collection-#{@topic_collection.galleries.count + 1}"
  #   end
  #   @latestAttach = TopicCollectionWideCoverGallery.create(:attachment => params[:attachment], :attachable => @topic_collection, :file_name => display_name) if params[:attachment]

  #   @topic_collection.update(admin_topic_collection_params) 
    
  #   respond_to do |format|
  #     if @topic_collection.save
  #       format.html { redirect_to :back, notice: '更新成功' }
  #     else
  #       format.html { render :back, notice: @topic_collection.errors.full_messages }
  #     end      
  #   end
  # end

  # PATCH/PUT /admin/topic_collections/1
  # PATCH/PUT /admin/topic_collections/1.json
  def update
    # if params[:filename].present? 
    #   display_name = params[:filename] 
    # else 
    #   display_name = "#{@topic_collection.name}-topic_collection-#{@topic_collection.galleries.count + 1}"
    # end
    # @latestAttach = TopicCollectionPhotoGallery.create(:attachment => params[:attachment], :attachable => @topic_collection, :file_name => display_name) if params[:attachment]

    @topic_collection.update ( admin_topic_collection_params )
    
    respond_to do |format|
      if @topic_collection.save
        format.html { redirect_to edit_admin_topic_collection_path(@topic_collection), notice: 'Successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: :back }
        format.json { render json: @topic_collection.errors, status: :unprocessable_entity }
      end
    end

  end

  # DELETE /admin/topic_collections/1
  # DELETE /admin/topic_collections/1.json
  def destroy
    @topic_collection.destroy
    respond_to do |format|
      flash[:notice] = "刪除成功"
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_topic_collection
    @topic_collection = TopicCollection.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def admin_topic_collection_params
    params.require(:topic_collection).permit(:name, :limit, :status, :attachment)
  end

end
