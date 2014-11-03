#encoding: utf-8
class Measurement < ActiveRecord::Base

  belongs_to :product

  validates_presence_of :title

end
