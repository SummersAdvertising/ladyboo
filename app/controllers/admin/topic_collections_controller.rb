#encoding: utf-8
class Admin::TopicCollectionsController < AdminController

  before_action :set_topic_collection, only: [:show, :edit, :update, :destroy]
  #, :create_topic_collection_attachment, :create_selected_product_attachment
  
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
    exclude_ids = @topic_collection.topics.pluck(:id)
    if exclude_ids.length != 0
      @topics = Topic.where('id not in (?)', exclude_ids)
    else
      @topics = Topic.all
    end

    @topic_collection_topicship = TopicCollectionTopicship.new
  end

  # PATCH/PUT /admin/topic_collections/1
  # PATCH/PUT /admin/topic_collections/1.json
  def update
  
    @topic_collection.update ( admin_topic_collection_params )
    
    respond_to do |format|
      if @topic_collection.save
        format.html { redirect_to admin_topic_collections_path, notice: 'Successfully updated.' }
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
    params.require(:topic_collection).permit(:name, :limit, :status)
  end

end
