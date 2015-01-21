#encoding: utf-8
class Admin::DailyReportsController < AdminController

  before_action :set_admin_daily_report, only: [:show, :update, :destroy]
  #, :create_daily_report_attachment, :create_selected_product_attachment
  
  # GET /admin/daily_reports
  # GET /admin/daily_reports.json
  def index 
    @daily_reports = DailyReport.all
  end

  #new
  def new
    @daily_report = DailyReport.new
  end

  def create

    @daily_report = DailyReport.new(admin_daily_report_params)

    #deal with attachment
    if params[:filename].present?
      display_name = params[:filename]
    else
      display_name = "#{@daily_report.title}-BANNER-#{@daily_report.galleries.count + 1}"
    end

    respond_to do |format|
      if @daily_report.save
        @latestAttach = DailyReportGallery.create(:attachment => params[:attachment], :attachable => @daily_report, :file_name => display_name) if params[:attachment]
        flash[:notice] = "更新成功"
        format.html { redirect_to admin_daily_reports_path() }
        #format.js {render :js => "window.location.href=window.location.href;"}
      else
        format.html { redirect_to :back , notice: @daily_report.errors.full_messages }
      end
    end  
  end

  # GET /admin/daily_reports/1
  # GET /admin/daily_reports/1.json
  def show
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
    @daily_report.destroy
    respond_to do |format|
      flash[:notice] = "刪除成功"
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
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
