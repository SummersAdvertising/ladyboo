#encoding: utf-8
class Admin::RevenueDetailsController < AdminController
  before_action :set_type
  # GET /admin/daily_reports
  # GET /admin/daily_reports.json
  def index 
     @revenue_details = SumByCategory.all
  end



  # GET /admin/daily_reports/1
  # GET /admin/daily_reports/1.json
  def show
    
  end

  # DELETE /admin/daily_reports/1
  # DELETE /admin/daily_reports/1.json
  def destroy
    
  end

  private
  
  def set_type
   @type = type
  end

  def type
    RevenueDetail.types.include?(params[:type]) ? params[:type] : "RevenueDetail"
  end

  def type_class 
    type.constantize 
  end


end
