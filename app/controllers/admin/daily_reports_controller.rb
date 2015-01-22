#encoding: utf-8
class Admin::DailyReportsController < AdminController

  before_action :set_admin_daily_report, only: [:show, :update, :destroy]
  #, :create_daily_report_attachment, :create_selected_product_attachment
  
  # GET /admin/daily_reports
  # GET /admin/daily_reports.json
  def index 
    @yesterday_report = DailyReport.latest_report
    @daily_reports = DailyReport.list_by_created.page(params[:page])
    @realtime_todolist_order_count = Order.todolist.count #待處理訂單數
    @realtime_pending_order_count = Order.pending.count #待付款訂單數
    @realtime_human_involved_order_count = Order.human_involved.count #人為處理訂單數
    @realtime_shipped_order_count = Order.shipped.count # 已出貨訂單數
    @realtime_total_active_order_count = @realtime_todolist_order_count + @realtime_pending_order_count + @realtime_human_involved_order_count + @realtime_shipped_order_count
  end

  # GET /admin/daily_reports/1
  # GET /admin/daily_reports/1.json
  def show
    unless @daily_report.blank?
      
      @sumup_by_category = @daily_report.sum_by_category
      @sumup_by_product = @daily_report.sum_by_product
      @sumup_by_stock = @daily_report.sum_by_stock

    end
  end

  def view_by_range
    # default
    begin_date = Date.today - 70.days
    end_date = Date.today

    unless params[:q].blank?
      unless params[:q][:target_date_gteq].blank?
        begin_date = Date.parse(params[:q][:target_date_gteq])

        unless params[:q][:target_date_lteq].blank?
          end_date = Date.parse(params[:q][:target_date_lteq])

          if begin_date > end_date
            tmp = end_date
            end_date = begin_date
            begin_date = tmp
          end

        else
          end_date = Date.today  
        end

      else
        begin_date = Date.today - 70.days
      end 

      params[:q][:target_date_gteq] = begin_date
      params[:q][:target_date_lteq] = end_date

      @q = DailyReport.search(params[:q])
      @daily_reports = @q.result(distinct: true)

      @begin_date = begin_date
      @end_date = end_date

      @sumup_report = DailyReport.slice_by_date_range(@begin_date, @end_date)
    else
      @q = DailyReport.empty_start.search(params[:q])
      @daily_reports = @q.result(distinct: true)
    end
    
  end

  # DELETE /admin/daily_reports/1
  # DELETE /admin/daily_reports/1.json
  def destroy
    # @daily_report.destroy
    # respond_to do |format|
    #   flash[:notice] = "刪除成功"
    #   format.html { redirect_to :back }
    #   format.json { head :no_content }
    # end
  end

  private
  
  # def set_type
  #   @type = type
  # end

  # def type
  #   RevenueDetail.types.include?(params[:type]) ? params[:type] : "RevenueDetail"
  # end

  # def type_class
  #   type.constantize
  # end

  # def set_revenue_detail
  #   @revenue_detail = type_class.find(params[:id])
  # end

  # Use callbacks to share common setup or constraints between actions.
  def set_admin_daily_report
    @daily_report = DailyReport.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def admin_daily_report_params
    params.require(:daily_report).permit(:title, :description, :ranking, :status)
  end

end
