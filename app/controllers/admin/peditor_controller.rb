class Admin::PeditorController < AdminController
  #create photo
  def createPhoto
    
    @photo = Photo.new(params.require(:photo).permit( :image, :name, :height, :width ))
    
    @photo.article_id = params[:id]
    
    respond_to do |format|
      if @photo.save
        
      # @photo.image.build_custom_photo
      
        format.json { render json: @photo, status: :created, location: @photo }
        format.js
      else
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroyPhoto
    @photo = Photo.find(params[:id])
    @photopath = "public/uploads/peditor/article/"+ @photo.article_id.to_s + "/" + @photo.id.to_s + "-" + @photo.name
    File.delete(@photopath) #carrierwave will handle this.
    #File.delete( "public/uploads/peditor/article/"+ @photo.article_id.to_s + "/" + @photo.id.to_s + "-peditor-" + @photo.name )
    
    @photo.destroy

    respond_to do |format|
          format.html { redirect_to :controller => 'photos', :action => 'index' }
          format.js
          format.json { head :no_content }
      end
  end
end
