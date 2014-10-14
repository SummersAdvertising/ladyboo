#encoding: utf-8
module OrderitemsHelper
  def generate_product_link(item)
    link_to "#{ item[:name] }", category_product_path(Stock.find(item[:id]).product.category.id,item[:product_id]), target: '_blank'
  end

  def get_product_of(item)

    stock = Stock.find_by_id(item.product_stock_id)
    
    if stock 
      if stock.product
        return stock.product
      else
        return nil
      end
    else
      return nil
    end

  end

end