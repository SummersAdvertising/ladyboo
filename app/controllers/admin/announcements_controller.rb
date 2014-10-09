#encoding: utf-8
class Admin::AnnouncementsController < AdminController
  
  layout :resolve_layout

  before_action :set_announcement, only: [:show, :edit, :custom_edit, :update, :destroy, :create_announcement_attachment]
  #before_action :announcement_type, only: [:create, :update]

  def index

    @announcements = Announcement.for_admin.page(params[:page])
    #@new_announcement = Announcement.new
  end
  
  #把所有 action 依照 type做區分
  def create

    if announcement_type == "PeditorAnnouncement"
      @announcement = PeditorAnnouncement.create()
      @announcement.article = Article.new

      respond_to do |format|
        if @announcement.save
          format.html { redirect_to edit_admin_announcement_path(@announcement), notice: 'announcement was successfully created.' }
        else
          format.html { redirect_to :back, notice: @announcement.errors.full_messages }
        end
      end
    elsif announcement_type == "CustomizedAnnouncement"
      
      @announcement = CustomizedAnnouncement.create()

      respond_to do |format|
        if @announcement.save
          format.html { redirect_to custom_edit_admin_announcement_path(@announcement), notice: 'announcement was successfully created.' }
        else
          format.html { redirect_to :back, notice: @announcement.errors.full_messages }
        end
      end

    end

    

  end

  # GET /admin/announcements/1/edit
  def edit
    @gallery_count = @announcement.galleries.select{ |v| v['type'] == "AnnouncementCoverGallery" }.count
  end

  def custom_edit
    @gallery_count = @announcement.galleries.select{ |v| v['type'] == "AnnouncementCoverGallery" }.count
  end
  # tab-2: announcement photo uploads
  # def announcementphoto_upload
    
  # end

  def create_announcement_attachment
      #deal with attachment
    if params[:filename].present? 
      display_name = params[:filename] 
    else 
      display_name = "#{@announcement.title}-ANNOUNCEMENT-#{@announcement.galleries.count + 1}"
    end
    @latestAttach = AnnouncementCoverGallery.create(:attachment => params[:attachment], :attachable => @announcement, :file_name => display_name) if params[:attachment]
    
    respond_to do |format|
       format.js {render :js => "window.location.href=window.location.href"}
    end
  end
  
  # PATCH/PUT /admin/announcements/1
  # PATCH/PUT /admin/announcements/1.json
  def update

    if announcement_type == "PeditorAnnouncement"
    
      if params[:filename].present? 
        display_name = params[:filename]
      else 
        display_name = "#{@announcement.title}-ANNOUNCEMENT-#{@announcement.galleries.count + 1}"
      end
      
      @latestAttach = AnnouncementCoverGallery.create(:attachment => params[:attachment], :attachable => @announcement, :file_name => display_name) if params[:attachment]

      respond_to do |format|
        if @announcement.update(announcement_params) && params[ :article ].nil? ^ @announcement.article.update( params.require(:article).permit(:content) )
          format.html { redirect_to edit_admin_announcement_path(@announcement), notice: 'Announcement was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: :edit }
          format.json { render json: @announcement.errors, status: :unprocessable_entity }
        end
      end
    elsif announcement_type == "CustomizedAnnouncement"

      if params[:filename].present? 
        display_name = params[:filename]
      else 
        display_name = "#{@announcement.title}-ANNOUNCEMENT-#{@announcement.galleries.count + 1}"
      end
      
      @latestAttach = AnnouncementCoverGallery.create(:attachment => params[:attachment], :attachable => @announcement, :file_name => display_name) if params[:attachment]

      respond_to do |format|
        if @announcement.update(announcement_params)
          format.html { redirect_to custom_edit_admin_announcement_path(@announcement), notice: 'Announcement was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: :back }
          format.json { render json: @announcement.errors, status: :unprocessable_entity }
        end
      end
    end
      
    
  end

  # DELETE /admin/announcements/1
  # DELETE /admin/announcements/1.json
  def destroy

    @announcement.destroy
    respond_to do |format|
      format.html { redirect_to admin_announcements_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_announcement
    @announcement = Announcement.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def announcement_params
    #params.require(:announcement).permit(:title, :subtitle, :article_id, :ranking)
    #EXAMPLE OF nest_attr: {:galleries_attributes => [:attachment , :id]}
    params.require(announcement_type.tableize.singularize).permit(:title, :subtitle, :article_id, :ranking, :attachment, :status, :ck_context )
  end


  def resolve_layout
    case action_name
    when "show" 
      if announcement_type == "CustomizedAnnouncement" 
        return "customizedpage"
      else
        return "admin"  
      end
    else
      return "admin"
    end
  end

  def announcement_types
    ["PeditorAnnouncement", "CustomizedAnnouncement"]
  end

  def announcement_type
    if !params[:type].nil?
      params[:type] if params[:type].in? announcement_types
    else
      @announcement.type if @announcement.type.in? announcement_types
    end
     
  end

end