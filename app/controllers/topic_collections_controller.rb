#encoding: utf-8
class TopicCollectionsController < ApplicationController
  
  before_action :set_topic_collection, only: [:show]

  def index
    @topic_collections = TopicCollection.all
  end

  def show
    #begin 
      if @topic_collection
        # each topic_collection only related to A TOPIC in this project
        @topic = @topic_collection.topics.first
        related_product_id = @topic.products.pluck(:id)
        @products = Product.where(id: related_product_id, status: 'enable').includes(:category, :galleries).page(params[:page])
        # all topic_collections
        @topic_collections = TopicCollection.where(status: 'enable').limit(4)
      else
        redirect_to root_path, notice: 'not found'
      end 
    # rescue
    #   redirect_to root_path
    # end
  end

  private

  def set_topic_collection
    @topic_collection = TopicCollection.where(status: 'enable').find(params[:id])
  end

end