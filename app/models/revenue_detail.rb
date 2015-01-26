# encoding: utf-8
class RevenueDetail < ActiveRecord::Base
  belongs_to :daily_report

  scope :sum_by_category, -> { where(type: 'SumByCategory').order(:category_name, :product_name, :stock_name) } 
  scope :sum_by_product, -> { where(type: 'SumByProduct').order(:category_name, :product_name, :stock_name) } 
  scope :sum_by_stock, -> { where(type: 'SumByStock').order(:category_name, :product_name, :stock_name) }

  def self.types
    %w(SumByCategory SumByProduct SumByStock)
  end

  def self.top_ten_by_type(type)
    case(type)
      when "ByCategory"
        RevenueDetail.sum_by_category.group(:category_name).sum(:figure).sort_by{|k,v| v}.reverse
      when "ByProduct"
        RevenueDetail.sum_by_product.group(:category_name,:product_name).sum(:figure).sort_by{|k,v| v}.reverse
      when "ByStock"
        RevenueDetail.sum_by_stock.group(:category_name,:product_name, :stock_name).sum(:figure).sort_by{|k,v| v}.reverse
    end    
  end

  def self.combine_display_name(category_name = "其他", product_name = "其他", stock_name = "其他")

    display_name = "#{category_name} - "
    display_name = display_name + "#{product_name} - "
    display_name = display_name + "#{stock_name}"

    return display_name
    
  end

end

class SumByCategory < RevenueDetail
end

class SumByProduct < RevenueDetail
end

class SumByStock < RevenueDetail
end
