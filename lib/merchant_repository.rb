require 'csv'
require_relative 'merchant'
require_relative 'sales_engine'

class MerchantRepository
  attr_accessor :merchants,
                :sales_engine

  def initialize(merchants_data, sales_engine)
    @sales_engine = sales_engine


    @merchants ||= merchants_data.map do |merchant|
      Merchant.new(merchant, self)
    end
  end

  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end

  def all
    merchants
  end

  def find_by_id(merchant_id)
    merchants.find { |merchant| merchant.id == merchant_id }
  end

  def find_by_name(merchant_name)
    merchants.find do |merchant|
      merchant.name.downcase == merchant_name.downcase
    end
  end

  def find_all_by_name(merchant_name)
    merchants.find_all do |merchant|
      merchant.name.downcase.include?(merchant_name.downcase)
    end
  end

  def merchants_created_in_month(month)
    merchants.find_all do |merchant|
      merchant.created_at.strftime("%B").downcase == month.downcase
    end
  end
end
