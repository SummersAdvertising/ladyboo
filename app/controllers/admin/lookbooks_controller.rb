#encoding: utf-8
class Admin::LookbooksController < AdminController

  before_action :set_lookbook, only: [:show, :edit, :update, :destroy]
  #, :create_lookbook_attachment, :create_selected_product_attachment
  
  # GET /admin/lookbooks
  # GET /admin/lookbooks.json
  def index 
    @lookbooks = Lookbook.all #.for_admin
  end

  #new
  def new
    @lookbook = Lookbook.new
  end

  def create
    @lookbook = Lookbook.new(admin_lookbook_params)

    respond_to do |format|
      if @lookbook.save
        flash[:notice] = "更新成功"
        format.html { redirect_to admin_lookbooks_path() }
        #format.js {render :js => "window.location.href=window.location.href;"}
      else
        format.html { redirect_to :back , notice: @lookbook.errors.full_messages }
      end
    end  
  end

  # GET /admin/lookbooks/1
  # GET /admin/lookbooks/1.json
  def show
  end

  # GET /admin/lookbooks/1/edit
  def edit
    exclude_ids = @lookbook.topics.pluck(:id)
    if exclude_ids.length != 0
      @topics = Topic.where('id not in (?)', exclude_ids)
    else
      @topics = Topic.all
    end

    @lookbook_topicship = LookbookTopicship.new
  end

  # PATCH/PUT /admin/lookbooks/1
  # PATCH/PUT /admin/lookbooks/1.json
  def update
  
    @lookbook.update ( admin_lookbook_params )
    
    respond_to do |format|
      if @lookbook.save
        format.html { redirect_to admin_lookbooks_path, notice: 'Successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: :back }
        format.json { render json: @lookbook.errors, status: :unprocessable_entity }
      end
    end

  end

  # DELETE /admin/lookbooks/1
  # DELETE /admin/lookbooks/1.json
  def destroy
    @lookbook.destroy
    respond_to do |format|
      flash[:notice] = "刪除成功"
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_lookbook
    @lookbook = Lookbook.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def admin_lookbook_params
    params.require(:lookbook).permit(:name, :limit, :status)
  end

end
