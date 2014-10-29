#encoding: utf-8
class Stock < ActiveRecord::Base
  # resourcify
  
  belongs_to :product
  has_many :galleries, through: :product

  scope :by_product, ->(product_id) { where("product_id = ?", product_id) }
  scope :assigned_amount, -> { where("assign_amount = ?", true) }

  validates_presence_of :name, :description_1, :description_2, :amount, :product_id
  validates :amount, numericality: { greater_than_or_equal_to: 0 }

  before_validation :check_attrs

  def check_attrs
    self.name = "#{self.description_1}-#{self.description_2}"
    self.amount = 0 if self.amount.blank?
    self.assign_amount = false if self.assign_amount.nil?
    return true
  end
end
