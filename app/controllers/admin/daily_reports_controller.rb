#encoding: utf-8
class Admin::DailyReportsController < AdminController

  before_action :set_admin_daily_report, only: [:show, :update, :destroy]
  #, :create_daily_report_attachment, :create_selected_product_attachment
  
  # GET /admin/daily_reports
  # GET /admin/daily_reports.json
  def index 
    @yesterday_report = DailyReport.latest_report
    @daily_reports = DailyReport.list_by_created.page(params[:page])
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

  # GET /admin/daily_reports/1/edit
  # def edit
  #   # selected product
  #   @products = Announcement.all
  # end

  # PATCH/PUT /admin/daily_reports/1
  # PATCH/PUT /admin/daily_reports/1.json
  # def update
  #   #@daily_report = DailyReport.find(params[:id])
  #   # thought-1: depends on type
  #   @daily_report.update ( admin_daily_report_params )
    
  #   respond_to do |format|
  #     if @daily_report.save
  #       format.html { redirect_to admin_daily_reports_path, notice: 'Successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: :back }
  #       format.json { render json: @daily_report.errors, status: :unprocessable_entity }
  #     end
  #   end

  # end

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
  # Use callbacks to share common setup or constraints between actions.
  def set_admin_daily_report
    @daily_report = DailyReport.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def admin_daily_report_params
    params.require(:daily_report).permit(:title, :description, :ranking, :status)
  end

end
