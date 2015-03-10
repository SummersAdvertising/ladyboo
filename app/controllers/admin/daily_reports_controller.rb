#encoding: utf-8
class Admin::DailyReportsController < AdminController

  before_action :set_admin_daily_report, only: [:show, :update, :destroy]
  before_action :set_chart_params, only: [:index, :show]
  
  # GET /admin/daily_reports
  # GET /admin/daily_reports.json
  def index 

    @yesterday_report = DailyReport.latest_report
    @daily_reports = DailyReport.list_by_target_date.page(params[:page])

    @realtime_todolist_order_count = Order.todolist.count #待處理訂單數
    @realtime_pending_order_count = Order.pending_without_vaccount.count #待付款訂單數
    @realtime_human_involved_order_count = Order.human_involved.count #人為處理訂單數
    @realtime_shipped_order_count = Order.shipped.count # 已出貨訂單數
    @realtime_total_active_order_count = @realtime_todolist_order_count + @realtime_pending_order_count + @realtime_human_involved_order_count + @realtime_shipped_order_count

    @all_close_orders_count = Order.where(aasm_state: 'close').count #總完成訂單
    @all_hold_orders_count = Order.where(aasm_state: 'hold').count #總最後確認跳出訂單
    @all_abnormal_orders_count = Order.where(aasm_state: 'abnormal').count #總經人為處理結束訂單
    @all_cancel_orders_count = Order.where(aasm_state: 'cancel').count #總取消訂單
    @all_orders_count = Order.count #總訂單
    # return an array
    #[ is_return_all, is_length_zero, category_revenue_details, product_revenue_details, stock_revenue_details ]
    @revenue_details = RevenueDetail.show_top_ten_revenue() 
    @product_revenue_amount = DailyReport.sum(:total_product_revenue)

    #chart
    # top 10 (doughnut)
    for i in 2..4
      @revenue_details[i].each_with_index do |record, index|
        if @product_revenue_amount > 0
          @chart_data_array[i-2] << { value: record[1] , color: @colors[index], highlight: @highlight_colors[index], label: "#{record[0][i-2]}(#{((record[1].to_f/@product_revenue_amount)*100).round(3)} %)" }
        else
          @chart_data_array[i-2] << { value: record[1] , color: @colors[index], highlight: @highlight_colors[index], label: "#{record[0][i-2]}" }
        end
      end
      @chart_data_array[i-2].delete_at(0)
    end
    # total revenue in last 12 month (bar)
    @begin_date = DailyReport.order('target_date asc').first.target_date.to_datetime;@end_date = DailyReport.order('target_date desc').first.target_date.to_datetime;
    date_range = @begin_date..@end_date
    date_months = date_range.map {|d| Date.new(d.year, d.month, 1) }.uniq.first(12)
    # collection of beginning of month, then strftime to readable format
    @last_12_months_seq = date_months.map { |d| d.strftime("%y %b") }
    @last_12_months_revenue_seq = []
    date_months.each do | current_month |
      total_revenue_sum = DailyReport.where(target_date: current_month.beginning_of_month..current_month.end_of_month).order(created_at: :desc).select('SUM(total_order_count) AS total_order_count, SUM(onhold_order_count) AS onhold_order_count, SUM(valid_order_count) AS valid_order_count, SUM(completed_order_count) AS completed_order_count, SUM(cancel_order_count) AS cancel_order_count, SUM(cancel_order_count) AS cancel_order_count, SUM(abnormal_end_order_count) AS abnormal_end_order_count, SUM(new_member_count) AS new_member_count, SUM(new_member_count) AS new_member_count, SUM(total_shipping_revenue) AS total_shipping_revenue, SUM(total_product_revenue) AS total_product_revenue , SUM(total_revenue) AS total_revenue ')[0]['total_revenue']
      @last_12_months_revenue_seq << ( total_revenue_sum.blank? ? 0 : total_revenue_sum )
    end
    # ORIGIN
    # @last_12_months_seq = []
    # for i in 1..12
    #   @last_12_months_seq << (DateTime.now - ((i-1).month)).strftime("%y'%m月")
    # end
    # @last_12_months_seq = @last_12_months_seq.reverse
    # @last_12_months_revenue_seq = []
    # for i in 1..12
    #   target_date = DateTime.now - ((i-1).month)
    #   total_revenue = DailyReport.where(target_date: target_date.beginning_of_month..target_date.end_of_month).order(created_at: :desc).select('SUM(total_order_count) AS total_order_count, SUM(onhold_order_count) AS onhold_order_count, SUM(valid_order_count) AS valid_order_count, SUM(completed_order_count) AS completed_order_count, SUM(cancel_order_count) AS cancel_order_count, SUM(cancel_order_count) AS cancel_order_count, SUM(abnormal_end_order_count) AS abnormal_end_order_count, SUM(new_member_count) AS new_member_count, SUM(new_member_count) AS new_member_count, SUM(total_shipping_revenue) AS total_shipping_revenue, SUM(total_product_revenue) AS total_product_revenue , SUM(total_revenue) AS total_revenue ')[0]['total_revenue']
    #   @last_12_months_revenue_seq << (total_revenue.blank? ? 0 : total_revenue)
    # end
    # @last_12_months_revenue_seq = @last_12_months_revenue_seq.reverse
    # ORIGIN END
    #chart end

  end

  # GET /admin/daily_reports/1
  # GET /admin/daily_reports/1.json
  def show
    unless @daily_report.blank?
      
      @sumup_by_category = @daily_report.sum_by_category
      @sumup_by_product = @daily_report.sum_by_product
      @sumup_by_stock = @daily_report.sum_by_stock

      @revenue_details = RevenueDetail.show_top_ten_revenue(@daily_report.id) # return an array
      @product_revenue_amount = @daily_report.total_product_revenue

      #chart
      for i in 2..4
        @revenue_details[i].each_with_index do |record, index|
          if @product_revenue_amount > 0
            @chart_data_array[i-2] << { value: record[1] , color: @colors[index], highlight: @highlight_colors[index], label: "#{record[0][i-2]}(#{((record[1].to_f/@product_revenue_amount)*100).round(3)} %)" }
          else
            @chart_data_array[i-2] << { value: record[1] , color: @colors[index], highlight: @highlight_colors[index], label: "#{record[0][i-2]}" }
          end
        end
        @chart_data_array[i-2].delete_at(0)
      end
      #chart end

    end
  end

  def view_by_range
    
    compose_query_condition(true) 
    @daily_reports = @q.result(distinct: true).list_by_target_date

    @query_condition = params[:q]

    @each_day_in_range = [] # strftime format
    # chart 
    # 日區間 - 總營業額
    query_range = @daily_reports.pluck(:target_date)
    query_range.each do |date|
      @each_day_in_range << date.strftime("%y %b %d")
    end
    @each_day_in_range = @each_day_in_range.reverse
    @query_range_revenue = DailyReport.where(target_date: query_range).pluck(:total_revenue)
    # 日區間 END

    # 月區間 - 總營業額
    date_range = @begin_date..@end_date
    date_months = date_range.map {|d| Date.new(d.year, d.month, 1) }.uniq 
    # collection of beginning of month, then strftime to readable format
    @readable_date_months = date_months.map { |d| d.strftime("%y %b") }
    # sum each month in scope
    @query_range_revenue_by_month = []
    date_months.each do | current_month |
      total_revenue_sum = DailyReport.where(target_date: current_month.beginning_of_month..current_month.end_of_month).order(created_at: :desc).select('SUM(total_order_count) AS total_order_count, SUM(onhold_order_count) AS onhold_order_count, SUM(valid_order_count) AS valid_order_count, SUM(completed_order_count) AS completed_order_count, SUM(cancel_order_count) AS cancel_order_count, SUM(cancel_order_count) AS cancel_order_count, SUM(abnormal_end_order_count) AS abnormal_end_order_count, SUM(new_member_count) AS new_member_count, SUM(new_member_count) AS new_member_count, SUM(total_shipping_revenue) AS total_shipping_revenue, SUM(total_product_revenue) AS total_product_revenue , SUM(total_revenue) AS total_revenue ')[0]['total_revenue']
      @query_range_revenue_by_month << ( total_revenue_sum.blank? ? 0 : total_revenue_sum )
    end
    # 月區間 END

    # 週區間 - 總營業額
    @date_weeks = []
    @query_range_revenue_by_week = []
    current_begin_date = @begin_date
    current_end_date = @begin_date + 6.days
    while current_end_date < @end_date
      @date_weeks << "#{current_begin_date.strftime("%y %b %d")}~#{current_end_date.strftime("%y %b %d")}"
      total_revenue_sum = DailyReport.where(target_date: current_begin_date.beginning_of_day..current_end_date.end_of_day).order(created_at: :desc).select('SUM(total_order_count) AS total_order_count, SUM(onhold_order_count) AS onhold_order_count, SUM(valid_order_count) AS valid_order_count, SUM(completed_order_count) AS completed_order_count, SUM(cancel_order_count) AS cancel_order_count, SUM(cancel_order_count) AS cancel_order_count, SUM(abnormal_end_order_count) AS abnormal_end_order_count, SUM(new_member_count) AS new_member_count, SUM(new_member_count) AS new_member_count, SUM(total_shipping_revenue) AS total_shipping_revenue, SUM(total_product_revenue) AS total_product_revenue , SUM(total_revenue) AS total_revenue ')[0]['total_revenue']
      @query_range_revenue_by_week << ( total_revenue_sum.blank? ? 0 : total_revenue_sum )
      current_begin_date, current_end_date = current_end_date + 1.days , current_end_date += 1.weeks
    end

    @date_weeks << "#{current_begin_date.strftime("%y %b %d")}~#{@end_date.strftime("%y %b %d")}"
    total_revenue_sum = DailyReport.where(target_date: current_begin_date.beginning_of_day..@end_date.end_of_day).order(created_at: :desc).select('SUM(total_order_count) AS total_order_count, SUM(onhold_order_count) AS onhold_order_count, SUM(valid_order_count) AS valid_order_count, SUM(completed_order_count) AS completed_order_count, SUM(cancel_order_count) AS cancel_order_count, SUM(cancel_order_count) AS cancel_order_count, SUM(abnormal_end_order_count) AS abnormal_end_order_count, SUM(new_member_count) AS new_member_count, SUM(new_member_count) AS new_member_count, SUM(total_shipping_revenue) AS total_shipping_revenue, SUM(total_product_revenue) AS total_product_revenue , SUM(total_revenue) AS total_revenue ')[0]['total_revenue']
    @query_range_revenue_by_week << ( total_revenue_sum.blank? ? 0 : total_revenue_sum )
    # 週區間 END

    # chart end
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
      if params[:q][:target_date_eq].blank?
        
        unless params[:q][:target_date_gteq].blank?
          begin_date = Date.parse(params[:q][:target_date_gteq])

          unless params[:q][:target_date_lteq].blank?
            end_date = Date.parse(params[:q][:target_date_lteq])

            if begin_date > end_date
              begin_date, end_date = end_date, begin_date
            end

          else
            end_date = Date.today  
          end

        else
          begin_date = Date.today - 70.days
        end 

      else #target_date_eq

        begin_date = Date.parse(params[:q][:target_date_eq])
        params[:q][:target_date_eq] = ''

      end # target_date_eq

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

  def set_chart_params
    @colors = ["#F7464A", "#46BFBD", "lightblue", "lightgreen", "tomato", "pink", "yellow", "red", "blue", "silver"]
    @highlight_colors = ["#FF5A5E", "#5AD3D1", "blue", "green", "red", "red", "lightyellow"]
    @chart_data_array = Array.new(3) { Array.new(1) }
  end
end
