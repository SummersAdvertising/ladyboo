#encoding: utf-8
class ProductsController < ApplicationController

  def show
    begin 
      @product = Product.includes(:galleries).front_show_by_cate(params[:category_id].to_i).find_by_id(params[:id])
      if @product
        @category = Category.find(Category.find(params[:category_id]).parent_id) 
      else
        redirect_to categories_path, notice: "找不到商品" and return
      end
      respond_to do |format|
        if(@product)
          #@categories = Category.without_root_node
          @current_root = Category.return_root_node
          @categories = Category.get_level_hierarchy()

          cart_items = JSON.parse_if_json(cookies[:cart_ladyboo]) || Hash.new
          @amount_in_cart = cart_items[@product.stocks.first.id.to_s] ||= 0
          #@category = @categories.detect {|category| category.id == @product.category_id }
          
          format.html
        else
          format.html { redirect_to category_path(params[:category_id]), alert: "找不到商品" }
        end
      end
    rescue
      redirect_to categories_path
    end
  end
end