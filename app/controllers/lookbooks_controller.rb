#encoding: utf-8
class LookbooksController < ApplicationController
  
  before_action :set_lookbook, only: [:show]

  def index
    @lookbooks = Lookbook.all
  end

  def show
    begin 
      if @lookbook
        # each lookbook can related to mutiple topics in this project
        @topics = @lookbook.topics
        related_product_id = @lookbook.products.pluck(:id)
        @products = Product.where(id: related_product_id, status: 'enable').includes(:category, :galleries).page(params[:page])

      end
    rescue
      redirect_to lookbooks_path
    end
  end

  private

  def set_lookbook
    @lookbook = Lookbook.where(status: 'enable').find(params[:id])
  end

end