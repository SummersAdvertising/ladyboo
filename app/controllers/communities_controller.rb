#encoding: utf-8
class CommunitiesController < ApplicationController
  layout :resolve_layout

  before_action :set_community, only: [:show]

  def index

    @communities = Community.for_index.page(params[:page])
    
  end
  

  def show
    @communities = Community.for_index

    # Ugly but have to ... coz ranking 
    # Next community and previous community
    @communities.each_with_index do |community, index|
      @index_of_record = index if community == @community
    end
    
    @communities[@index_of_record+1] ? @next_community = @communities[@index_of_record+1] : @next_community = nil
    if @index_of_record == 0
      @previous_community = nil
    else
      @communities[@index_of_record-1] ? @previous_community = @communities[@index_of_record-1] : @previous_community = nil
    end

  end

  

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_community
    begin
      @community = Community.for_index.find(params[:id])
    rescue
      #flash[:notice] = "文章不存在"
      redirect_to communities_path and return
    end
  end

  def resolve_layout
    case action_name
    when "show" 
      if community_type == "CustomizedCommunity" 
        return "application"  
        #return "customizedpage"
      else
        return "application"  
      end
    else
      return "application"
    end
  end

  def community_types
    ["PeditorCommunity", "CustomizedCommunity"]
  end

  def community_type
    if !params[:type].nil?
      params[:type] if params[:type].in? community_types
    else
      @community.type if @community.type.in? community_types
    end
     
  end

end