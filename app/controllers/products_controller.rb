#encoding: utf-8
class ProductsController < ApplicationController

  before_action :recently_viewed

  def show
    begin
      @product = Product.includes(:galleries).front_show_by_cate(params[:category_id].to_i).find_by_id(params[:id])
      if @product
        @category = Category.find(Category.find(params[:category_id]).parent_id)
      else
        redirect_to categories_path, notice: "找不到商品" and return
      end

      #@url = fetch_stock_amount_category_product_path
      
      @measurements = @product.measurements.where(status: 'enable')

      respond_to do |format|
        if(@product)
          #@categories = Category.without_root_node
          # @current_root = Category.return_root_node
          # @categories = Category.get_level_hierarchy()

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

  def fetch_stock_amount
    begin
      if params[:stock_id] && params[:stock_id].to_i > 0
        @stock = Stock.find(params[:stock_id])

        @product = @stock.product
        cart_items = JSON.parse_if_json(cookies[:cart_ladyboo]) || Hash.new

        @amount_in_cart = cart_items[params[:stock_id]] ||= 0

      end

      respond_to do |format|
        format.js
      end
    rescue
      redirect_to categories_path
    end
  end

  def quickview

    # begin
      @product = Product.includes(:galleries).find_by_id(params[:id])

      if @product #params[:category_id]
        @category_id = @product.category.id
        @category = Category.find(Category.find(@category_id).parent_id)
      else
        redirect_to categories_path, notice: "找不到商品" and return
      end

      @measurements = @product.measurements.where(status: 'enable')

      respond_to do |format|
        if(@product)
          cart_items = JSON.parse_if_json(cookies[:cart_ladyboo]) || Hash.new
          @amount_in_cart = cart_items[@product.stocks.first.id.to_s] ||= 0
          #@category = @categories.detect {|category| category.id == @product.category_id }

          format.js
        else
          format.html { redirect_to category_path(params[:category_id]), alert: "找不到商品" }
        end
      end
    # rescue
    #   redirect_to categories_path
    # end

  end

  private

  def recently_viewed
    if request.url.split('products/').last.to_s =~ /\A\d+\Z/
      session[:recently_viewed] ||= []
      if Product.find(request.url.split('products/').last.to_i)
        session[:recently_viewed].delete_at(0) if session[:recently_viewed].size >= 12
        temp_array = session[:recently_viewed]
        temp_array << request.url.split('products/').last.to_s =~ /\A\d+\Z/
        session[:recently_viewed] = temp_array.uniq
      end
    end
  end

end
