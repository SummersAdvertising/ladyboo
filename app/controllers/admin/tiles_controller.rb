#encoding: utf-8
class Admin::TilesController < AdminController
  #authorize_resource
  before_action :set_tile, only: [:update ,:destroy]

  def index
    @tiles = Tile.by_lookbook(params[:lookbook_id]).all
    @tile = Tile.new

    
    @lookbook = Lookbook.find_by_id(params[:lookbook_id])
    # @category = @lookbook.category if @lookbook
    
  end
  # 使tile有序, 非gallery ; index 不編輯, 只排序 #
  # => 可思考 tile順序在 主題 edit 排 ; 編輯則要進 tile 自己的index
  def create
    @tile = Tile.new(tile_params.merge({:lookbook_id => params[:lookbook_id]}))
    @tile.save

    if params[:filename].present? 
      display_name = params[:filename]
    else 
      display_name = "#{Time.now.strftime('%Y%m%d%s')}-tile-#{@tile.galleries.count + 1}"
    end
      
    @latestAttach = TileCoverGallery.create(:attachment => params[:attachment], :attachable => @tile, :file_name => display_name) if params[:attachment]
    
    respond_to do |format|
      format.html { redirect_to :back }
    end
  end

  def update
    
    @tile.update_attributes(tile_params) if @tile
    
    if params[:filename].present? 
      display_name = params[:filename]
    else 
      display_name = "#{Time.now.strftime('%Y%m%d%s')}-tile-#{@tile.galleries.count + 1}"
    end
      
    @latestAttach = TileCoverGallery.create(:attachment => params[:attachment], :attachable => @tile, :file_name => display_name) if params[:attachment]

    redirect_to :back
  end

  def destroy
    @tile.destroy if @tile

    redirect_to :back
  end

  def reorder
    errorFlag = false
    params[:tiles][:reorderset].each_with_index do | tileid , index |
      the_tile = Tile.find(tileid)
      if !the_tile.nil?
        the_tile.update_attribute(:ranking , index+1 )
      else
        errorFlag = true
      end
    end

    respond_to do |format|
      if errorFlag
        format.json { head :no_content }
      else
        flash[:notice] = "重新排序成功"
        format.json do render json: flash end
      end
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tile
      @tile = Tile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tile_params
      params.require(:tile).permit(:context_1, :context_2, :context_3, :context_4, :context_5, :attachment, :topic_id)
    end
end