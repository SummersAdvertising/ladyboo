class Photo < ActiveRecord::Base
  belongs_to :article

    mount_uploader :image, PeditorImageUploader
    
    before_create :update_filename
    #validates_uniqueness_of :name, :on => :create
    
  private
  def update_filename
    self.name = image.file.filename
  end
  
end
