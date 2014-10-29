#encoding: utf-8
class TopicsController < ApplicationController
  
  before_action :set_topic, only: [:show]

  def show
    #begin 
      @lookbook = Lookbook.where(status: 'enable').find(params[:lookbook_id])
      if @topic && @lookbook
        # each lookbook can related to mutiple topics in this project
        related_product_id = @topic.products.pluck(:id)
        @products = Product.where(id: related_product_id, status: 'enable').includes(:category, :galleries).page(params[:page])
        
        @topics = @lookbook.topics
      end
    # rescue
    #   redirect_to topics_path
    # end
  end

  private

  def set_topic
    @topic = Topic.includes(:galleries).find(params[:id])
  end

end