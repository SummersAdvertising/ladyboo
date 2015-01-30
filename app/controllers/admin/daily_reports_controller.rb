#encoding: utf-8
class Admin::DailyReportsController < AdminController

  before_action :set_admin_daily_report, only: [:show, :update, :destroy]
  
  # GET /admin/daily_reports
  # GET /admin/daily_reports.json
  def index 
    @yesterday_report = DailyReport.latest_report
    @daily_reports = DailyReport.list_by_target_date.page(params[:page])

    @realtime_todolist_order_count = Order.todolist.count #待處理訂單數
    @realtime_pending_order_count = Order.pending.count #待付款訂單數
    @realtime_human_involved_order_count = Order.human_involved.count #人為處理訂單數
    @realtime_shipped_order_count = Order.shipped.count # 已出貨訂單數
    @realtime_total_active_order_count = @realtime_todolist_order_count + @realtime_pending_order_count + @realtime_human_involved_order_count + @realtime_shipped_order_count

    @all_close_orders_count = Order.where(aasm_state: 'close').count #總完成訂單
    @all_hold_orders_count = Order.where(aasm_state: 'hold').count #總最後確認跳出訂單
    @all_abnormal_orders_count = Order.where(aasm_state: 'abnormal').count #總經人為處理結束訂單
    @all_cancel_orders_count = Order.where(aasm_state: 'cancel').count #總取消訂單
    @all_orders_count = Order.count #總訂單

    @by_category_revenue_details = RevenueDetail.top_ten_by_type('ByCategory')
    @by_product_revenue_details = RevenueDetail.top_ten_by_type('ByProduct')
    @by_stock_revenue_details = RevenueDetail.top_ten_by_type('ByStock')

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
    
    compose_query_condition(true) 
    @daily_reports = @q.result(distinct: true)

    @query_condition = params[:q]

  end

  def export_csv
    
    compose_query_condition(false) 
    @daily_reports = @q.result(distinct: true)

    respond_to do |format|
      format.html
      format.csv { send_data text: @daily_reports.to_csv }
    end

  end

  def export_xls
    
    compose_query_condition(false) 
    @daily_reports = @q.result(distinct: true)

    respond_to do |format|
      format.html
      format.xls {
        send_data DailyReport.to_xls(@daily_reports), :type => :xls, :filename => "#{@begin_date}-#{@end_date}-report.xls";
      }
    end

  end

  private
  
  def compose_query_condition(first_response_empty = true)
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
      @sumup_report = DailyReport.slice_by_date_range(begin_date, end_date)
    else
      if first_response_empty
        @q = DailyReport.empty_start.search(params[:q])
      else
        params[:q][:target_date_gteq] = begin_date
        params[:q][:target_date_lteq] = end_date
        @q = DailyReport.search(params[:q])
        @sumup_report = DailyReport.slice_by_date_range(begin_date, end_date)
      end
    end
    
    @begin_date = begin_date
    @end_date = end_date

  end  

  # Use callbacks to share common setup or constraints between actions.
  def set_admin_daily_report
    @daily_report = DailyReport.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def admin_daily_report_params
    params.require(:daily_report).permit(:title, :description, :ranking, :status)
  end

end
