#encoding: utf-8
class Admin::BannersController < AdminController

  before_action :set_admin_banner, only: [:show, :update, :destroy]
  #, :create_banner_attachment, :create_selected_product_attachment
  
  # GET /admin/banners
  # GET /admin/banners.json
  def index 
    @banners = Banner.for_admin
  end

  #new
  def new
    @banner = Banner.new
  end

  def create

      @banner = Banner.new(admin_banner_params)

      #deal with attachment
      if params[:filename].present?
        display_name = params[:filename]
      else
        display_name = "#{@banner.title}-BANNER-#{@banner.galleries.count + 1}"
      end

      respond_to do |format|
        if @banner.save
          @latestAttach = BannerGallery.create(:attachment => params[:attachment], :attachable => @banner, :file_name => display_name) if params[:attachment]
          flash[:notice] = "更新成功"
          format.html { redirect_to admin_banners_path() }
          #format.js {render :js => "window.location.href=window.location.href;"}
        else
          format.html { redirect_to :back , notice: @banner.errors.full_messages }
        end
      end  
  end

  # GET /admin/banners/1
  # GET /admin/banners/1.json
  def show
  end

  # GET /admin/banners/1/edit
  # def edit
  #   # selected product
  #   @products = Announcement.all
  # end

  # PATCH/PUT /admin/banners/1
  # PATCH/PUT /admin/banners/1.json
  # def update
  #   #@banner = Banner.find(params[:id])
  #   # thought-1: depends on type
  #   @banner.update ( admin_banner_params )
    
  #   respond_to do |format|
  #     if @banner.save
  #       format.html { redirect_to admin_banners_path, notice: 'Successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: :back }
  #       format.json { render json: @banner.errors, status: :unprocessable_entity }
  #     end
  #   end

  # end

  # DELETE /admin/banners/1
  # DELETE /admin/banners/1.json
  def destroy
    @banner.destroy
    respond_to do |format|
      flash[:notice] = "刪除成功"
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_admin_banner
    @banner = Banner.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def admin_banner_params
    params.require(:banner).permit(:title, :description, :ranking, :status)
  end

end
