#encoding: utf-8
class Admin::GalleriesController < AdminController
  
  #multiReorder
  def multiple_reorder
    errorFlag = false
    params[:gallerries][:reorderset].each_with_index do | attachmentid , index | 
        @fAttachment = Gallery.find(attachmentid)
        if !@fAttachment.nil?
            @fAttachment.update_attribute(:ranking , index+1 )
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

  def destroy
    @gallery = Gallery.find(params[:id])

        # public/uploads/attachment/#{model.attachable_type}/#{model.attachable_id}/attachment/#{model.id}
    #-- delete file only (remain lots of empty folder)
    #@attachmentpath = "public/uploads/attachment/" + @attachment.attachable_type.to_s + "/" + @attachment.attachable_id.to_s + "/attachment/" + @attachment.id.to_s + "/" + @attachment.file_name
    #File.delete(@attachmentpath)
    #-- delete file only end
    #delete entire folder 
    @attachmentpath = "public/uploads/gallery/" + @gallery.attachable_type.to_s + "/" + @gallery.attachable_id.to_s + "/attachment/" + @gallery.id.to_s
    FileUtils.rm_rf(@attachmentpath)
    
    respond_to do |format|
      flash[:notice] = "刪除成功"
      format.html { redirect_to :back }
    end

    @gallery.destroy
      
  end

end