module ApplicationHelper
  def list_recently_viewed(viewed_array)
    if viewed_array && viewed_array.count > 0
      viewed_products = Product.includes(:category, :galleries).where(id: viewed_array)
      render partial: 'products/recently_viewed', locals: { products: viewed_products }
    end
  end
end
