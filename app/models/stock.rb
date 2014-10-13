#encoding: utf-8
class ProductStock < ActiveRecord::Base
  resourcify
  
  belongs_to :product

  scope :by_product, ->(product_id) { where("product_id = ?", product_id) }
  scope :assigned_amount, -> { where("assign_amount = ?", true) }

  validates_presence_of :name, :amount, :product_id
  validates :amount, numericality: { greater_than_or_equal_to: 0 }

  before_validation :check_attrs

  def check_attrs
    self.name = "預設庫存" if self.name.blank?
    self.amount = 0 if self.amount.blank?
    self.assign_amount = false if self.assign_amount.nil?
    return true
  end
end
