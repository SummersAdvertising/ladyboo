#encoding: utf-8
module CategoriesHelper
  # not in use
  def list_product(current_product)
    if current_product.galleries.select{ |v| v['type'] == 'ProductPhotoGallery' }.count > 0
      "<div class='pull-left'> #{link_to( image_tag(current_product.galleries.select{ |v| v['type'] == 'ProductPhotoGallery' }.first.attachment.url, class: 'img-responsive' ) , category_product_path(@category, current_product)) }</div>".html_safe
    else
      #link_to "#{current_product.name}<br>$#{current_product.price_for_sale}元/#{current_product.unit}".html_safe , product_cate_product_path(@product_cate, current_product)
    end
  end

end