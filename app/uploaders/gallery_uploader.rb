# encoding: utf-8
class GalleryUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::MiniMagick
  #include CarrierWave::MimeTypes
  
  # temporarily doesn't need these
  # version :productphoto, :if => :is_product? do 
  #   process resize_and_pad(500, 500)
  # end

  # version :taste_attribute, :if => :is_taste_attribute? do 
  #   process resize_and_pad(300, 300)
  # end
  # version :banner, :if => :is_banner? do 
  #   process resize_and_pad(100, 100)
  # end
  
  # Choose what kind of storage to use for this uploader:
  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{model.attachable_type}/#{model.attachable_id}/#{mounted_as}/#{model.id}"
  end
  
  def extension_white_list
    %w(jpg jpeg gif png)
  end
  # temporarily doesn't need these
  # protected
  
  # def is_product? 
  #   model.type == "ProductPhotoGallery"
  # end

  # def is_taste_attribute? picture
  #   model.type == "TasteAttributeGallery"
  # end

  # def is_banner? picture
  #   model.type == "Banner"
  # end

end
