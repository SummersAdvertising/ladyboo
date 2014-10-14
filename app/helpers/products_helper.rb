#encoding: utf-8
module ProductsHelper

  def show_keypoints(all_keypoints)
    keypoints_detail = ""
    all_keypoints.each do |k,v| 
      keypoints_detail << "<li>#{v}</li>" unless v.empty?
    end

    return keypoints_detail.html_safe
  end

  def show_taste_sttributes(all_attributes)
    attr_detail = "<ul>"
    all_attributes.each do |k,v| 
      attr_detail << "<li>#{v}</li>" unless v.empty?
    end
    attr_detail << "</ul>"
    return attr_detail.html_safe
  end

  # content_tag(:h5) do
  #   product_cate.name
  # end
      
  def show_product_cate(active_cate, product_cate)
    if product_cate == active_cate
      "<li class ='active'>#{ link_to( product_cate.name, category_path(product_cate.id) ) }</li>".html_safe
    elsif product_cate.depth == 1
      content_tag(:h5) do
        product_cate.name
      end
    else
      "<li>#{ link_to( product_cate.name, category_path(product_cate.id) ) }</li>".html_safe
    end
  end

  def no_products_msg(count)
    if(count == 0)
      "<p>分類底下無商品</p>".html_safe
    end
  end

  def show_price_for_sale(price_for_sale)
    if(price_for_sale > 0)
      "折扣價：#{ price_for_sale } <br>".html_safe
    end
  end

  def get_change_status_name(product)
    case product.status
    when "disable"
      "重新上架"
    when "enable"
      "物品下架"
    end 
  end
end
