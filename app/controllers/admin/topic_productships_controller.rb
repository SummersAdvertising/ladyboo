#encoding: utf-8
class Admin::TopicProductshipsController < AdminController

  before_action :set_topic_productship, only: [:show, :edit, :update, :destroy]
  #, :create_topic_productship_attachment, :create_selected_product_attachment
  
  # GET /admin/topic_productships
  # GET /admin/topic_productships.json
  def index 
    @topic_productships = TopicProductship.all #.for_admin
  end

  #new
  def new
    @topic_productship = TopicProductship.new
  end

  def create

      @topic_productship = TopicProductship.new(admin_topic_productship_params)

      respond_to do |format|
        if @topic_productship.save
          flash[:notice] = "更新成功"
          format.html { redirect_to edit_admin_topic_path(@topic_productship.topic_id) }
          #format.js {render :js => "window.location.href=window.location.href;"}
        else
          format.html { redirect_to :back , notice: @topic_productship.errors.full_messages }
        end
      end  
  end

  # GET /admin/topic_productships/1
  # GET /admin/topic_productships/1.json
  def show
  end

  # GET /admin/topic_productships/1/edit
  def edit
    exclude_ids = @topic_productship.products.pluck(:id)
    if exclude_ids.length != 0
      @products = Product.where('id not in (?)', exclude_ids)
    else
      @products = Product.all
    end

    @topic_productship_productship = TopicProductship.new
  end

  # PATCH/PUT /admin/topic_productships/1
  # PATCH/PUT /admin/topic_productships/1.json
  def update
  
    @topic_productship.update ( admin_topic_productship_params )
    
    respond_to do |format|
      if @topic_productship.save
        format.html { redirect_to admin_topic_productships_path, notice: 'Successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: :back }
        format.json { render json: @topic_productship.errors, status: :unprocessable_entity }
      end
    end

  end

  # DELETE /admin/topic_productships/1
  # DELETE /admin/topic_productships/1.json
  def destroy
    @topic_productship.destroy
    respond_to do |format|
      flash[:notice] = "刪除成功"
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_topic_productship
    @topic_productship = TopicProductship.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def admin_topic_productship_params
    params.require(:topic_productship).permit(:topic_id, :product_id)
  end

end
