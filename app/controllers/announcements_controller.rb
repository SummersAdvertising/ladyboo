#encoding: utf-8
class AnnouncementsController < ApplicationController
  layout :resolve_layout

  before_action :set_announcement, only: [:show]

  def index

    @announcements = Announcement.for_index.page(params[:page])
    
  end
  

  def show
    @announcements = Announcement.for_index

    # Ugly but have to ... coz ranking 
    # Next announcement and previous announcement
    @announcements.each_with_index do |announcement, index|
      @index_of_record = index if announcement == @announcement
    end
    
    @announcements[@index_of_record+1] ? @next_announcement = @announcements[@index_of_record+1] : @next_announcement = nil
    if @index_of_record == 0
      @previous_announcement = nil
    else
      @announcements[@index_of_record-1] ? @previous_announcement = @announcements[@index_of_record-1] : @previous_announcement = nil
    end

  end

  

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_announcement
    begin
      @announcement = Announcement.for_index.find(params[:id])
    rescue
      #flash[:notice] = "文章不存在"
      redirect_to announcements_path and return
    end
  end

  def resolve_layout
    case action_name
    when "show" 
      if announcement_type == "CustomizedAnnouncement" 
        return "application"  
        #return "customizedpage"
      else
        return "application"  
      end
    else
      return "application"
    end
  end

  def announcement_types
    ["PeditorAnnouncement", "CustomizedAnnouncement"]
  end

  def announcement_type
    if !params[:type].nil?
      params[:type] if params[:type].in? announcement_types
    else
      @announcement.type if @announcement.type.in? announcement_types
    end
     
  end

end