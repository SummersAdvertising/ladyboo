#encoding: utf-8
class Admin::LookbookTopicshipsController < AdminController

  before_action :set_lookbook_topicships, only: [:show, :edit, :update, :destroy]
  #, :create_lookbook_topicships_attachment, :create_selected_product_attachment
  
  # GET /admin/lookbook_topicshipss
  # GET /admin/lookbook_topicshipss.json
  def index 
    @lookbook_topicshipss = LookbookTopicship.all #.for_admin
  end

  #new
  def new
    @lookbook_topicships = LookbookTopicship.new
  end

  def create

      @lookbook_topicships = LookbookTopicship.new(admin_lookbook_topicships_params)

      respond_to do |format|
        if @lookbook_topicships.save
          flash[:notice] = "更新成功"
          format.html { redirect_to edit_admin_lookbook_path(@lookbook_topicships.lookbook_id) }
          #format.js {render :js => "window.location.href=window.location.href;"}
        else
          format.html { redirect_to :back , notice: @lookbook_topicships.errors.full_messages }
        end
      end  
  end

  # GET /admin/lookbook_topicshipss/1
  # GET /admin/lookbook_topicshipss/1.json
  def show
  end

  # GET /admin/lookbook_topicshipss/1/edit
  def edit
    exclude_ids = @lookbook_topicships.products.pluck(:id)
    if exclude_ids.length != 0
      @products = Product.where('id not in (?)', exclude_ids)
    else
      @products = Product.all
    end

    @lookbook_topicships_productship = LookbookTopicship.new
  end

  # PATCH/PUT /admin/lookbook_topicshipss/1
  # PATCH/PUT /admin/lookbook_topicshipss/1.json
  def update
  
    @lookbook_topicships.update ( admin_lookbook_topicships_params )
    
    respond_to do |format|
      if @lookbook_topicships.save
        format.html { redirect_to admin_lookbook_topicshipss_path, notice: 'Successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: :back }
        format.json { render json: @lookbook_topicships.errors, status: :unprocessable_entity }
      end
    end

  end

  # DELETE /admin/lookbook_topicshipss/1
  # DELETE /admin/lookbook_topicshipss/1.json
  def destroy
    @lookbook_topicships.destroy
    respond_to do |format|
      flash[:notice] = "刪除成功"
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_lookbook_topicships
    @lookbook_topicships = LookbookTopicship.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def admin_lookbook_topicships_params
    params.require(:lookbook_topicship).permit(:topic_id, :lookbook_id)
  end

end
