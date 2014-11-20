module ApplicationHelper

  def list_recently_viewed(viewed_array)
    if viewed_array && viewed_array.count > 0
      viewed_products = Product.includes(:category, :galleries).where(id: viewed_array)
      render partial: 'products/recently_viewed', locals: { products: viewed_products }
    end
  end

  def aside_link(link_text, link_path)
    class_name = current_page?(link_path) ? 'active' : ''

    content_tag(:li, class: class_name) do
      link_to link_text, link_path
    end
  end
  # def controller?(*controller)
  #   controller.include?(params[:controller])
  # end

  # def action?(*action)
  #   action.include?(params[:action])
  # end
  
end
