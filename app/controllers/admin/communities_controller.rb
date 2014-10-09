#encoding: utf-8
class Admin::CommunitiesController < AdminController
  
  layout :resolve_layout

  before_action :set_community, only: [:show, :edit, :custom_edit, :update, :destroy, :create_community_attachment]
  #before_action :community_type, only: [:create, :update]

  def index

    @communities = Community.for_admin.page(params[:page])
    #@new_community = Community.new
  end
  
  #把所有 action 依照 type做區分
  def create

    if community_type == "PeditorCommunity"
      @community = PeditorCommunity.create()
      @community.article = Article.new

      respond_to do |format|
        if @community.save
          format.html { redirect_to edit_admin_community_path(@community), notice: 'community was successfully created.' }
        else
          format.html { redirect_to :back, notice: @community.errors.full_messages }
        end
      end
    elsif community_type == "CustomizedCommunity"
      
      @community = CustomizedCommunity.create()

      respond_to do |format|
        if @community.save
          format.html { redirect_to custom_edit_admin_community_path(@community), notice: 'community was successfully created.' }
        else
          format.html { redirect_to :back, notice: @community.errors.full_messages }
        end
      end

    end

    

  end

  # GET /admin/communities/1/edit
  def edit
    @gallery_count = @community.galleries.select{ |v| v['type'] == "CommunityCoverGallery" }.count
  end

  def custom_edit
    @gallery_count = @community.galleries.select{ |v| v['type'] == "CommunityCoverGallery" }.count
  end
  # tab-2: community photo uploads
  # def communityphoto_upload
    
  # end

  def create_community_attachment
      #deal with attachment
    if params[:filename].present? 
      display_name = params[:filename] 
    else 
      display_name = "#{@community.title}-community-#{@community.galleries.count + 1}"
    end
    @latestAttach = CommunityCoverGallery.create(:attachment => params[:attachment], :attachable => @community, :file_name => display_name) if params[:attachment]
    
    respond_to do |format|
       format.js {render :js => "window.location.href=window.location.href"}
    end
  end
  
  # PATCH/PUT /admin/communities/1
  # PATCH/PUT /admin/communities/1.json
  def update

    if community_type == "PeditorCommunity"
    
      if params[:filename].present? 
        display_name = params[:filename]
      else 
        display_name = "#{@community.title}-community-#{@community.galleries.count + 1}"
      end
      
      @latestAttach = CommunityCoverGallery.create(:attachment => params[:attachment], :attachable => @community, :file_name => display_name) if params[:attachment]

      respond_to do |format|
        if @community.update(community_params) && params[ :article ].nil? ^ @community.article.update( params.require(:article).permit(:content) )
          format.html { redirect_to edit_admin_community_path(@community), notice: 'Community was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: :edit }
          format.json { render json: @community.errors, status: :unprocessable_entity }
        end
      end
    elsif community_type == "CustomizedCommunity"

      if params[:filename].present? 
        display_name = params[:filename]
      else 
        display_name = "#{@community.title}-community-#{@community.galleries.count + 1}"
      end
      
      @latestAttach = CommunityCoverGallery.create(:attachment => params[:attachment], :attachable => @community, :file_name => display_name) if params[:attachment]

      respond_to do |format|
        if @community.update(community_params)
          format.html { redirect_to custom_edit_admin_community_path(@community), notice: 'Community was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: :back }
          format.json { render json: @community.errors, status: :unprocessable_entity }
        end
      end
    end
      
    
  end

  # DELETE /admin/communities/1
  # DELETE /admin/communities/1.json
  def destroy

    @community.destroy
    respond_to do |format|
      format.html { redirect_to admin_communities_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_community
    @community = Community.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def community_params
    #params.require(:community).permit(:title, :subtitle, :article_id, :ranking)
    #EXAMPLE OF nest_attr: {:galleries_attributes => [:attachment , :id]}
    params.require(community_type.tableize.singularize).permit(:title, :subtitle, :article_id, :ranking, :attachment, :status, :ck_context )
  end


  def resolve_layout
    case action_name
    when "show" 
      if community_type == "CustomizedCommunity" 
        return "customizedpage"
      else
        return "admin"  
      end
    else
      return "admin"
    end
  end

  def community_types
    ["PeditorCommunity", "CustomizedCommunity"]
  end

  def community_type
    if !params[:type].nil?
      params[:type] if params[:type].in? community_types
    else
      @community.type if @community.type.in? community_types
    end
     
  end

end