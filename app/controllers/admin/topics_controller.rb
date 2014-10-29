#encoding: utf-8
class Admin::TopicsController < AdminController

  before_action :set_topic, only: [:show, :edit, :update, :destroy]
  #, :create_topic_attachment, :create_selected_product_attachment
  
  # GET /admin/topics
  # GET /admin/topics.json
  def index 
    @topics = Topic.all #.for_admin
  end

  #new
  def new
    @topic = Topic.new
  end

  def create

      @topic = Topic.new(admin_topic_params)

      respond_to do |format|
        if @topic.save
          flash[:notice] = "更新成功"
          format.html { redirect_to admin_topics_path() }
          #format.js {render :js => "window.location.href=window.location.href;"}
        else
          format.html { redirect_to :back , notice: @topic.errors.full_messages }
        end
      end  
  end

  # GET /admin/topics/1
  # GET /admin/topics/1.json
  def show
  end

  # GET /admin/topics/1/edit
  def edit
    @gallery_count = @topic.galleries.select{ |v| v['type'] == "TopicCoverGallery" }.count

    exclude_ids = @topic.products.pluck(:id)
    if exclude_ids.length != 0
      @products = Product.where('id not in (?)', exclude_ids)
    else
      @products = Product.all
    end

    @topic_productship = TopicProductship.new
  end

  # PATCH/PUT /admin/topics/1
  # PATCH/PUT /admin/topics/1.json
  def update
    
    if params[:filename].present? 
      display_name = params[:filename] 
    else 
      display_name = "#{@topic.name}-topic-#{@topic.galleries.count + 1}"
    end
    @latestAttach = TopicCoverGallery.create(:attachment => params[:attachment], :attachable => @topic, :file_name => display_name) if params[:attachment]

    @topic.update ( admin_topic_params )
    
    respond_to do |format|
      if @topic.save
        format.html { redirect_to admin_topics_path, notice: 'Successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: :back }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end

  end

  def photo
    @topic = Topic.find_by_id(params[:topic_id])
    @gallery_count = @topic.galleries.select{ |v| v['type'] == "TopicBannerGallery" }.count
  end

  def upload_photo
    @topic = Topic.find_by_id(params[:topic_id])
    #deal with attachment
    if params[:filename].present? 
      display_name = params[:filename] 
    else 
      display_name = "#{@topic.name}-topic-#{@topic.galleries.count + 1}"
    end
    @latestAttach = TopicBannerGallery.create(:attachment => params[:attachment], :attachable => @topic, :file_name => display_name) if params[:attachment]

    @topic.update(admin_topic_params) 
    
    respond_to do |format|
      if @topic.save
        format.html { redirect_to :back, notice: '更新成功' }
      else
        format.html { render :back, notice: @topic.errors.full_messages }
      end      
    end
  end

  # DELETE /admin/topics/1
  # DELETE /admin/topics/1.json
  def destroy
    @topic.destroy
    respond_to do |format|
      flash[:notice] = "刪除成功"
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_topic
    @topic = Topic.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def admin_topic_params
    params.require(:topic).permit(:name, :attachment)
  end

end
