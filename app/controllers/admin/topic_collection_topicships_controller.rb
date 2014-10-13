#encoding: utf-8
class Admin::TopicCollectionTopicshipsController < AdminController

  before_action :set_topic_collection_topicship, only: [:show, :edit, :update, :destroy]
  #, :create_topic_collection_topicship_attachment, :create_selected_product_attachment
  
  # GET /admin/topic_collection_topicships
  # GET /admin/topic_collection_topicships.json
  def index 
    @topic_collection_topicships = TopicCollectionTopicship.all #.for_admin
  end

  #new
  def new
    @topic_collection_topicship = TopicCollectionTopicship.new
  end

  def create

      @topic_collection_topicship = TopicCollectionTopicship.new(admin_topic_collection_topicship_params)

      respond_to do |format|
        if @topic_collection_topicship.save
          flash[:notice] = "更新成功"
          format.html { redirect_to edit_admin_topic_collection_path(@topic_collection_topicship.topic_collection_id) }
          #format.js {render :js => "window.location.href=window.location.href;"}
        else
          format.html { redirect_to :back , notice: @topic_collection_topicship.errors.full_messages }
        end
      end  
  end

  # GET /admin/topic_collection_topicships/1
  # GET /admin/topic_collection_topicships/1.json
  def show
  end

  # GET /admin/topic_collection_topicships/1/edit
  def edit
    exclude_ids = @topic_collection_topicship.products.pluck(:id)
    if exclude_ids.length != 0
      @products = Product.where('id not in (?)', exclude_ids)
    else
      @products = Product.all
    end

    @topic_collection_topicship_productship = TopicCollectionTopicship.new
  end

  # PATCH/PUT /admin/topic_collection_topicships/1
  # PATCH/PUT /admin/topic_collection_topicships/1.json
  def update
  
    @topic_collection_topicship.update ( admin_topic_collection_topicship_params )
    
    respond_to do |format|
      if @topic_collection_topicship.save
        format.html { redirect_to admin_topic_collection_topicships_path, notice: 'Successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: :back }
        format.json { render json: @topic_collection_topicship.errors, status: :unprocessable_entity }
      end
    end

  end

  # DELETE /admin/topic_collection_topicships/1
  # DELETE /admin/topic_collection_topicships/1.json
  def destroy
    @topic_collection_topicship.destroy
    respond_to do |format|
      flash[:notice] = "刪除成功"
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_topic_collection_topicship
    @topic_collection_topicship = TopicCollectionTopicship.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def admin_topic_collection_topicship_params
    params.require(:topic_collection_topicship).permit(:topic_id, :topic_collection_id)
  end

end
